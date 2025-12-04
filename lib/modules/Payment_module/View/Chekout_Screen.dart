//my usable chekout screen code
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// import '../../../constant/constant_colors.dart';
// import '../../../utils/storageservice.dart';
// import '../../../utils/util_klass.dart';
// import '../../../widget/custombottombar.dart';
// import '../../My_course_module/Model/My_Course_Model.dart';
// import '../Controller/Chekout_Cotroller.dart';
//
// //  class OrderDraft {
// //   final int userId;
// //   final List<int> cartitemIds;
// //   final String firstName;
// //   final String lastName;
// //   final String countryName;
// //   final String companyName;
// //   final String streetAddress;
// //   final String apartmentNo;
// //   final String cityName;
// //   final String postCode;
// //   final String emailAddress;
// //   final String phoneNumber;
// //   final int amountRupee;
// //
// //   const OrderDraft({
// //     required this.userId,
// //     required this.cartitemIds,
// //     required this.firstName,
// //     required this.lastName,
// //     required this.countryName,
// //     required this.companyName,
// //     required this.streetAddress,
// //     required this.apartmentNo,
// //     required this.cityName,
// //     required this.postCode,
// //     required this.emailAddress,
// //     required this.phoneNumber,
// //     required this.amountRupee,
// //   });
// //
// //   @override
// //   String toString() {
// //     return 'OrderDraft(userId:$userId, items:${cartitemIds.length}, amount:$amountRupee, name:$firstName $lastName, email:$emailAddress, phone:$phoneNumber)';
// //   }
// // }
//
// class CheckoutScreen extends StatefulWidget {
//   final List<CartItem> cartItems;
//   const CheckoutScreen({super.key, required this.cartItems});
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final ChekoutController chekoutController = Get.find();
//
//   late Razorpay _razorpay;
//
//   // Billing inputs
//   final TextEditingController utrController = TextEditingController();
//   final TextEditingController firstName = TextEditingController();
//   final TextEditingController lastName = TextEditingController();
//   final TextEditingController companyName = TextEditingController();
//   final TextEditingController streetAddress = TextEditingController();
//   final TextEditingController apartment = TextEditingController();
//   final TextEditingController city = TextEditingController();
//   final TextEditingController country = TextEditingController();
//   final TextEditingController postcode = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController phone = TextEditingController();
//
//   XFile? selectedImage;
//   int selectedPaymentMethod = 0; // 0 = QR/UTR, 1 = Razorpay
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _prefillUserData();
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     firstName.dispose();
//     lastName.dispose();
//     companyName.dispose();
//     streetAddress.dispose();
//     apartment.dispose();
//     city.dispose();
//     country.dispose();
//     postcode.dispose();
//     email.dispose();
//     phone.dispose();
//     utrController.dispose();
//     super.dispose();
//   }
//
//   // ---------- Helpers ----------
//
//   int getTotalAmount() {
//     return widget.cartItems.fold(
//       0,
//       (sum, item) =>
//           sum + ((item.totalPrice ?? 0) * (item.quantity ?? 0)).toInt(),
//     );
//   }
//
//   List<int> _cartIds() => widget.cartItems
//       .map((e) => e.id)
//       .whereType<int>()
//       .where((id) => id > 0)
//       .toList();
//
//   OrderDraft _buildDraft() {
//     final draft = OrderDraft(
//       userId: StorageService.getData("User_id") ?? 0,
//       cartitemIds: _cartIds(),
//       firstName: firstName.text.trim(),
//       lastName: lastName.text.trim(),
//       countryName: country.text.trim(),
//       companyName: " ",
//       streetAddress: streetAddress.text.trim(),
//       apartmentNo: " ",
//       cityName: city.text.trim(),
//       postCode: postcode.text.trim(),
//       emailAddress: email.text.trim(),
//       phoneNumber: phone.text.trim(),
//       amountRupee: getTotalAmount(),
//     );
//     debugPrint("🧾 Draft => $draft");
//     return draft;
//   }
//
//   void _prefillUserData() {
//     final userEmail = StorageService.getData("email") ??
//         StorageService.getData("Login Email");
//     final userName = StorageService.getData("name") ?? "Student";
//
//     if (userEmail != null) email.text = userEmail;
//     final parts = userName.split(' ');
//     if (parts.isNotEmpty) firstName.text = parts[0];
//     if (parts.length > 1) lastName.text = parts.sublist(1).join(' ');
//   }
//
//   void _clearForm() {
//     firstName.clear();
//     lastName.clear();
//     companyName.clear();
//     streetAddress.clear();
//     apartment.clear();
//     city.clear();
//     country.clear();
//     postcode.clear();
//     email.clear();
//     phone.clear();
//     utrController.clear();
//     selectedImage = null;
//     setState(() {});
//   }
//
//   // ---------- Submit Flow ----------
//
//   Future<void> _submit() async {
//     FocusScope.of(context).unfocus();
//
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//
//     final ids = _cartIds();
//     if (ids.isEmpty) {
//       Get.snackbar('Error', 'Invalid cart items',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return;
//     }
//
//     if (selectedPaymentMethod == 0) {
//       // QR/UTR route
//       if (selectedImage == null || utrController.text.trim().isEmpty) {
//         Get.snackbar('Missing info', 'Please enter UTR & upload screenshot',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         return;
//       }
//       if (utrController.text.length < 10 || utrController.text.length > 16) {
//         Get.snackbar('Invalid UTR', 'UTR must be 10–16 characters',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         return;
//       }
//
//       final draft = _buildDraft();
//       await chekoutController.checkoutWithQRCode(
//         paymentScreenshot: File(selectedImage!.path),
//         draft: draft,
//         utrNo: utrController.text.trim(),
//       );
//
//       // If your controller sets a success flag, check it; here we just reset.
//       _clearForm();
//       UtilKlass.showToastMsg("Order Placed Successfully", context);
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const BottomnavBar()),
//         );
//       }
//     } else {
//       // Razorpay route
//       final draft = _buildDraft();
//       await chekoutController.startRazorpay(
//         draft: draft,
//         rzpKey: 'rzp_test_RYPjmxVz9OvnOa', // 🔑 test key
//         createOrderOnServer:
//             false, // set true when your backend /orders is ready
//       );
//       // On success your controller should internally call placeOrderAfterPayment()
//       // and navigate or expose a signal to you. Keep UI idle here.
//     }
//   }
//
//   // ---------- UI ----------
//
//   @override
//   Widget build(BuildContext context) {
//     final isTablet = MediaQuery.of(context).size.width > 600;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: AppBar(
//         title: Text(
//           "Checkout",
//           style: GoogleFonts.lato(
//             fontSize: isTablet ? 24 : 20,
//             fontWeight: FontWeight.bold,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(Icons.arrow_back_ios_new_rounded,
//               color: AppColors.textPrimary, size: isTablet ? 28 : 24),
//         ),
//       ),
//
//       // Keep body purely scrollable content (no Expanded here!)
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isTablet ? 24 : 16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sectionTitle("Billing Details", isTablet),
//               const SizedBox(height: 8),
//               _buildTextField(
//                 controller: firstName,
//                 label: "First Name",
//                 hint: "Enter your first name",
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: lastName,
//                 label: "Last Name",
//                 hint: "Enter your last name",
//                 isTablet: isTablet,
//               ),
//               // _buildTextField(
//               //   controller: companyName,
//               //   label: "Company Name",
//               //   hint: "Enter your company name",
//               //   isRequired: false,
//               //   isTablet: isTablet,
//               // ),
//               _buildTextField(
//                 controller: streetAddress,
//                 label: "Street Address",
//                 hint: "123 Main Street",
//                 isTablet: isTablet,
//               ),
//               // _buildTextField(
//               //   controller: apartment,
//               //   label: "Apartment No.",
//               //   hint: "Apt 3B",
//               //   isRequired: false,
//               //   isTablet: isTablet,
//               // ),
//               _buildTextField(
//                 controller: city,
//                 label: "City",
//                 hint: "Your city",
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: country,
//                 label: "Country",
//                 hint: "Your country",
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: postcode,
//                 label: "Postcode",
//                 hint: "123456",
//                 keyboardType: TextInputType.number,
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: email,
//                 label: "Email Address",
//                 hint: "you@example.com",
//                 keyboardType: TextInputType.emailAddress,
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: phone,
//                 label: "Phone Number",
//                 hint: "9876543210",
//                 keyboardType: TextInputType.phone,
//                 isTablet: isTablet,
//               ),
//
//               const SizedBox(height: 24),
//               _orderSummaryCard(isTablet),
//
//               const SizedBox(height: 16),
//               _buildPaymentMethodSelector(isTablet),
//
//               if (selectedPaymentMethod == 0) ...[
//                 const SizedBox(height: 12),
//                 _buildQRCodeSection(isTablet),
//               ] else ...[
//                 const SizedBox(height: 12),
//                 _buildRazorpayInfo(isTablet),
//               ],
//
//               const SizedBox(height: 24),
//               _otherPayments(isTablet),
//               const SizedBox(height: 24),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     Text(
//               //         "Pay with Google Pay • ₹${getTotalAmount()}",
//               //       style: GoogleFonts.lato(
//               //         fontSize: isTablet ? 18 : 16,
//               //         color: Colors.white,
//               //         fontWeight: FontWeight.bold,
//               //       ),
//               //     ),
//               //     const SizedBox(width: 8),
//               //     const Icon(Icons.arrow_forward, color: Colors.white),
//               //   ],
//               // ),
//               // const SizedBox(height: 100), // to avoid bottom button overlap
//             ],
//           ),
//         ),
//       ),
//
//       // Fixed bottom CTA
//       bottomNavigationBar: SafeArea(
//         child: Obx(() {
//           final busy = chekoutController.isLoading.value;
//           return Padding(
//             padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
//             child: SizedBox(
//               height: isTablet ? 56 : 52,
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: busy ? null : _submit,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 2,
//                 ),
//                 child: busy
//                     ? const SizedBox(
//                         width: 22,
//                         height: 22,
//                         child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white)),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             selectedPaymentMethod == 0
//                                 ? "Place Order (QR/UTR) • ₹${getTotalAmount()}"
//                                 : "Pay with Razorpay • ₹${getTotalAmount()}",
//                             style: GoogleFonts.lato(
//                               fontSize: isTablet ? 18 : 16,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           const Icon(Icons.arrow_forward, color: Colors.white),
//                         ],
//                       ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   // ---------- UI Builders ----------
//
//   Widget _sectionTitle(String text, bool isTablet) => Text(
//         text,
//         style: GoogleFonts.lato(
//           fontSize: isTablet ? 20 : 18,
//           fontWeight: FontWeight.bold,
//           color: AppColors.textPrimary,
//         ),
//       );
//
//   Widget _orderSummaryCard(bool isTablet) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(isTablet ? 20 : 16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Order Summary",
//               style: GoogleFonts.lato(
//                 fontSize: isTablet ? 18 : 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               )),
//           SizedBox(height: isTablet ? 12 : 8),
//
//           // Items
//           ...widget.cartItems.map((item) {
//             final lineAmount = (item.totalPrice ?? 0) * (item.quantity ?? 0);
//             return Padding(
//               padding: EdgeInsets.only(bottom: isTablet ? 8 : 6),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(item.courseName ?? 'Course',
//                         style: GoogleFonts.lato(
//                             fontSize: isTablet ? 16 : 14,
//                             color: AppColors.textPrimary),
//                         overflow: TextOverflow.ellipsis),
//                   ),
//                   Text("₹$lineAmount",
//                       style: GoogleFonts.lato(
//                           fontSize: isTablet ? 16 : 14,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textPrimary)),
//                 ],
//               ),
//             );
//           }),
//
//           const Divider(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Total:",
//                   style: GoogleFonts.lato(
//                       fontSize: isTablet ? 18 : 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary)),
//               Text("₹${getTotalAmount()}",
//                   style: GoogleFonts.lato(
//                       fontSize: isTablet ? 18 : 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaymentMethodSelector(bool isTablet) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Select Payment Method",
//               style: TextStyle(
//                   fontSize: isTablet ? 18 : 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _selectTile(
//                   isActive: selectedPaymentMethod == 0,
//                   //icon: Image.asset("assets/images/scannerimage.jpg") as IconData,
//                   icon: Icons.qr_code,
//                   title: "QR Code / UPI",
//                   subtitle: "Upload Screenshot",
//                   onTap: () => setState(() => selectedPaymentMethod = 0),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _selectTile(
//                   isActive: selectedPaymentMethod == 1,
//                   icon: Icons.credit_card,
//                   title: "Razorpay",
//                   subtitle: "Cards / UPI / Wallets",
//                   onTap: () => setState(() => selectedPaymentMethod = 1),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _selectTile({
//     required bool isActive,
//     required IconData? icon,
//     // String ? iconImage,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color:
//               isActive ? AppColors.primary.withOpacity(0.07) : Colors.grey[50],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: isActive ? AppColors.primary : Colors.grey.shade300,
//               width: 2),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: AppColors.primary, size: 28),
//             //Image.asset(iconImage.toString(), height: 40, width: 40),
//             const SizedBox(height: 8),
//             Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//             const SizedBox(height: 2),
//             Text(subtitle,
//                 style: const TextStyle(fontSize: 12, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQRCodeSection(bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 16 : 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 18.0),
//             child: Container(
//               height: 180,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   border: Border.all(color: AppColors.primary)),
//               child: Image.asset("assets/images/scannerimage.jpg",
//                   fit: BoxFit.contain),
//             ),
//           ),
//           _buildTextField(
//             controller: utrController,
//             label: "UTR Number",
//             hint: "Enter UTR number from payment",
//             isTablet: isTablet,
//             isRequired: true,
//           ),
//           const SizedBox(height: 8),
//           Text("Payment Screenshot",
//               style: TextStyle(
//                   fontWeight: FontWeight.w600, fontSize: isTablet ? 16 : 14)),
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: () async {
//               final XFile? img =
//                   await ImagePicker().pickImage(source: ImageSource.gallery);
//               if (img != null) setState(() => selectedImage = img);
//             },
//             child: Container(
//               height: 140,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: selectedImage == null
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(Icons.cloud_upload, size: 36, color: Colors.grey),
//                         SizedBox(height: 6),
//                         Text("Tap to upload payment screenshot",
//                             style: TextStyle(color: Colors.grey)),
//                       ],
//                     )
//                   : ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.file(File(selectedImage!.path),
//                           width: double.infinity, fit: BoxFit.cover),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRazorpayInfo(bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 16 : 14),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue[100]!),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.info, color: Colors.blue),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               "Secure Razorpay Payment\nPay via Cards, UPI, Netbanking, or Wallets on Razorpay’s checkout.",
//               style: TextStyle(
//                   fontSize: isTablet ? 15 : 14, color: Colors.blue[800]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _otherPayments(bool isTablet) {
//     return Column(
//       children: [
//         const Divider(),
//         const SizedBox(height: 12),
//         Text('Other Payment Methods',
//             style: GoogleFonts.lato(
//                 fontSize: isTablet ? 16 : 14, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 10),
//         OutlinedButton.icon(
//           onPressed: () => showPaymentDialog(context, isTablet),
//           icon: Icon(Icons.qr_code, color: AppColors.primary),
//           label: Text("Pay via UPI QR Code",
//               style: GoogleFonts.lato(
//                 fontSize: isTablet ? 16 : 14,
//                 color: AppColors.primary,
//                 fontWeight: FontWeight.w600,
//               )),
//           style: OutlinedButton.styleFrom(
//             minimumSize: Size(double.infinity, isTablet ? 50 : 46),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             side: BorderSide(color: AppColors.primary),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void showPaymentDialog(BuildContext context, bool isTablet) {
//     const String upiId = "9413561917@apl";
//
//     showCupertinoDialog(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(builder: (context, setSt) {
//           return CupertinoAlertDialog(
//             title: Text("Complete Payment",
//                 style: GoogleFonts.lato(
//                     fontSize: isTablet ? 20 : 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary)),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: isTablet ? 16 : 10),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.asset(
//                       'assets/images/scannerimage.jpg',
//                       height: isTablet ? 240 : 200,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   SizedBox(height: isTablet ? 16 : 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("UPI ID: $upiId",
//                           style: GoogleFonts.lato(
//                             fontSize: isTablet ? 18 : 16,
//                             color: AppColors.textPrimary,
//                           )),
//                       SizedBox(width: isTablet ? 12 : 8),
//                       CupertinoButton(
//                         padding: EdgeInsets.zero,
//                         child: Icon(Icons.copy,
//                             size: isTablet ? 24 : 20, color: AppColors.primary),
//                         onPressed: () {
//                           Clipboard.setData(const ClipboardData(text: upiId));
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("UPI ID copied",
//                                   style: GoogleFonts.lato(color: Colors.white)),
//                               backgroundColor: AppColors.primary,
//                               duration: const Duration(seconds: 2),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: isTablet ? 16 : 10),
//                   CupertinoTextField(
//                     controller: utrController,
//                     placeholder: "Enter 10-16 digit UTR or transaction ID",
//                     placeholderStyle: GoogleFonts.lato(
//                         color: Colors.grey[400], fontSize: isTablet ? 16 : 14),
//                     keyboardType: TextInputType.number,
//                     padding: EdgeInsets.all(isTablet ? 16 : 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: isTablet ? 16 : 10),
//                   CupertinoButton.filled(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: isTablet ? 24 : 16,
//                         vertical: isTablet ? 12 : 10),
//                     child: Text(
//                       selectedImage == null
//                           ? "Upload Payment Screenshot"
//                           : "Change Payment Screenshot",
//                       style: GoogleFonts.lato(
//                           fontSize: isTablet ? 16 : 15, color: Colors.white),
//                     ),
//                     onPressed: () async {
//                       final XFile? img = await ImagePicker()
//                           .pickImage(source: ImageSource.gallery);
//                       if (img != null) setSt(() => selectedImage = img);
//                     },
//                   ),
//                   SizedBox(height: isTablet ? 12 : 8),
//                   if (selectedImage != null)
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.file(File(selectedImage!.path),
//                             height: isTablet ? 120 : 100, fit: BoxFit.cover),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             actions: [
//               CupertinoDialogAction(
//                 isDestructiveAction: true,
//                 onPressed: () => Navigator.pop(context),
//                 child: Text("Cancel",
//                     style: GoogleFonts.lato(
//                         fontSize: isTablet ? 16 : 14,
//                         color: CupertinoColors.destructiveRed)),
//               ),
//               CupertinoDialogAction(
//                 isDefaultAction: true,
//                 onPressed: () async {
//                   if (utrController.text.isEmpty || selectedImage == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             "Please enter UTR and upload payment screenshot",
//                             style: GoogleFonts.lato(color: Colors.white)),
//                         backgroundColor: Colors.red,
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                     return;
//                   }
//                   if (utrController.text.length < 10 ||
//                       utrController.text.length > 16) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("UTR must be 10-16 digits",
//                             style: GoogleFonts.lato(color: Colors.white)),
//                         backgroundColor: Colors.red,
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                     return;
//                   }
//                   // Optional: trigger the same QR flow directly from dialog if you want
//                   await _submit();
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text("Place Order",
//                         style: GoogleFonts.lato(
//                             fontSize: 14, color: AppColors.primary)),
//                     const SizedBox(width: 8),
//                     Icon(Icons.arrow_forward,
//                         color: AppColors.primary, size: 16),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     TextInputType keyboardType = TextInputType.text,
//     bool isRequired = true,
//     bool isTablet = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isTablet ? 20 : 16),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         validator: (value) {
//           if (isRequired && (value == null || value.trim().isEmpty)) {
//             return '$label is required';
//           }
//           if (keyboardType == TextInputType.emailAddress &&
//               value != null &&
//               !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//             return 'Enter a valid email address';
//           }
//           if (keyboardType == TextInputType.phone &&
//               value != null &&
//               value.length < 10) {
//             return 'Enter a valid phone number';
//           }
//           return null;
//         },
//         style: GoogleFonts.lato(
//             fontSize: isTablet ? 16 : 14, color: AppColors.textPrimary),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: GoogleFonts.lato(
//               color: Colors.grey[600], fontSize: isTablet ? 16 : 14),
//           hintText: hint,
//           hintStyle: GoogleFonts.lato(
//               color: Colors.grey[400], fontSize: isTablet ? 16 : 14),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: EdgeInsets.symmetric(
//               vertical: isTablet ? 16 : 12, horizontal: isTablet ? 20 : 16),
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey.shade300)),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey.shade300)),
//           focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: AppColors.primary, width: 2)),
//         ),
//       ),
//     );
//   }
// }
//my usable chekout screen code

///New Chekout Screen///

library;

/// new screen code start ///
// import 'dart:io';
// import 'package:auratech_academy/utils/logx.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../constant/constant_colors.dart';
// import '../../../utils/storageservice.dart';
// import '../../../utils/util_klass.dart';
// import '../../../widget/custombottombar.dart';
// import '../../My_course_module/Model/My_Course_Model.dart';
// import '../Controller/Chekout_Cotroller.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   final List<CartItem> cartItems;
//   const CheckoutScreen({super.key, required this.cartItems});
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final ChekoutController chekoutController = Get.find();
//
//   // Billing inputs
//   final TextEditingController utrController = TextEditingController();
//   final TextEditingController firstName = TextEditingController();
//   final TextEditingController lastName = TextEditingController();
//   final TextEditingController companyName = TextEditingController();
//   final TextEditingController streetAddress = TextEditingController();
//   final TextEditingController apartment = TextEditingController();
//   final TextEditingController city = TextEditingController();
//   final TextEditingController country = TextEditingController();
//   final TextEditingController postcode = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController phone = TextEditingController();
//
//   XFile? selectedImage;
//   int selectedPaymentMethod = 0; // 0 = QR/UTR, 1 = Razorpay
//
//   @override
//   void initState() {
//     super.initState();
//     _prefillUserData();
//     LogX.printLog("🛒 Checkout initialized with ${widget.cartItems[0]} cart items");
//   }
//
//   @override
//   void dispose() {
//     firstName.dispose();
//     lastName.dispose();
//     companyName.dispose();
//     streetAddress.dispose();
//     apartment.dispose();
//     city.dispose();
//     country.dispose();
//     postcode.dispose();
//     email.dispose();
//     phone.dispose();
//     utrController.dispose();
//     super.dispose();
//   }
//
//   // ---------- Helpers ----------
//
//   int getTotalAmount() {
//     return widget.cartItems.fold(
//       0,
//           (sum, item) =>
//       sum + ((item.totalPrice ?? 0) * (item.quantity ?? 0)).toInt(),
//     );
//   }
//
//   int getTotalQty() {
//     return widget.cartItems.fold(
//       0,
//           (sum, item) => sum + (item.quantity ?? 0),
//     );
//   }
//
//   List<int> _cartIds() => widget.cartItems
//       .map((e) => e.id)
//       .whereType<int>()
//       .where((id) => id > 0)
//       .toList();
//
//   void _prefillUserData() {
//     final userEmail =
//         StorageService.getData("email") ?? StorageService.getData("Login Email");
//     final userName = StorageService.getData("name") ?? "Student";
//
//     if (userEmail != null) email.text = userEmail;
//     final parts = userName.split(' ');
//     if (parts.isNotEmpty) firstName.text = parts[0];
//     if (parts.length > 1) lastName.text = parts.sublist(1).join(' ');
//   }
//
//   void _clearForm() {
//     firstName.clear();
//     lastName.clear();
//     companyName.clear();
//     streetAddress.clear();
//     apartment.clear();
//     city.clear();
//     country.clear();
//     postcode.clear();
//     email.clear();
//     phone.clear();
//     utrController.clear();
//     selectedImage = null;
//     setState(() {});
//   }
//
//   // ---------- Order master API helper ----------
//
//   Future<bool> _createOrderOnServer({
//     required String paymentMode,
//     required String paymentResponse,
//     required bool paymentStatus,
//   }) async {
//     final int userId = StorageService.getData("User_id") ?? 0;
//     final int totalAmount = getTotalAmount();
//     final int totalQty = getTotalQty();
//     final String nowUtc = DateTime.now().toUtc().toIso8601String();
//
//     final String billingNameCombined =
//     "${firstName.text.trim()} ${lastName.text.trim()}".trim();
//
//     final String billingAddressCombined =
//     "${streetAddress.text.trim()}, ${city.text.trim()}, ${country.text.trim()} - ${postcode.text.trim()}".trim();
//
//     await chekoutController.createOrder(
//       userId: userId,
//      // courseId
//       date: nowUtc,
//       orderFrom: "App",
//       itemCount: widget.cartItems.length.toString(),
//       totalQty: totalQty.toString(),
//       totalAmt: totalAmount.toString(),
//       taxType: "Interstate", // TODO: agar dynamic hai to yahan map kar
//       igst: "10", // sample JSON jaisa; tum apna logic laga sakte ho
//       cgst: null,
//       scgst: null,
//       otherCharges: "40", // ya "0" / dynamic
//       discountAmt: "20", // ya "0" / coupon se
//       couponCode: "AURA10", // ya empty
//       netAmt: totalAmount.toString(), // ya logic se (total+tax-charges-discount)
//       billingName: billingNameCombined,
//       billingAddress: billingAddressCombined,
//       gstType: "CGST", // sample ke hisaab se
//       gstStateCode: "18",
//       description:
//       "Course purchase (${widget.cartItems.length} items) via $paymentMode",
//       orderStatus: paymentStatus,
//       paymentMode: paymentMode,
//       paymentResponse: paymentResponse,
//       paymentStatus: paymentStatus,
//       remarks: "ok",
//       extra: null,
//
//       orderDetails: [],
//
//     );
//
//     if (chekoutController.errorMessage.isNotEmpty) {
//       UtilKlass.showToastMsg(
//         "Failed to place order: ${chekoutController.errorMessage.value}",
//         context,
//       );
//       return false;
//     }
//
//     return true;
//   }
//
//   // ---------- Submit Flow ----------
//
//   Future<void> _submit() async {
//     FocusScope.of(context).unfocus();
//
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//
//     final ids = _cartIds();
//     if (ids.isEmpty) {
//       Get.snackbar('Error', 'Invalid cart items',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return;
//     }
//
//     String paymentMode;
//     String paymentResponse;
//     bool paymentStatus;
//
//     if (selectedPaymentMethod == 0) {
//       // QR/UTR route – order_master mein sirf meta store karein
//       if (selectedImage == null || utrController.text.trim().isEmpty) {
//         Get.snackbar('Missing info', 'Please enter UTR & upload screenshot',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         return;
//       }
//       if (utrController.text.length < 10 || utrController.text.length > 16) {
//         Get.snackbar('Invalid UTR', 'UTR must be 10–16 characters',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         return;
//       }
//
//       paymentMode = "CASH";
//       paymentResponse =
//       "Payment pending verification (UTR: ${utrController.text.trim()})";
//       paymentStatus = false; // admin verify karega
//     } else {
//       // Razorpay route – abhi direct success flag + meta store kar rahe hain
//       paymentMode = "RAZORPAY";
//       paymentResponse = "Razorpay payment initiated";
//       paymentStatus = true; // agar real RZP flow add karein to yahan update
//     }
//
//     final ok = await _createOrderOnServer(
//       paymentMode: paymentMode,
//       paymentResponse: paymentResponse,
//       paymentStatus: paymentStatus,
//     );
//
//     if (!ok) return;
//
//     _clearForm();
//     UtilKlass.showToastMsg("Order Placed Successfully", context);
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const BottomnavBar()),
//       );
//     }
//   }
//
//   // ---------- UI ----------
//
//   @override
//   Widget build(BuildContext context) {
//     final isTablet = MediaQuery.of(context).size.width > 600;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: AppBar(
//         title: Text(
//           "Checkout",
//           style: GoogleFonts.lato(
//             fontSize: isTablet ? 24 : 20,
//             fontWeight: FontWeight.bold,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(Icons.arrow_back_ios_new_rounded,
//               color: AppColors.textPrimary, size: isTablet ? 28 : 24),
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isTablet ? 24 : 16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sectionTitle("Billing Details", isTablet),
//               const SizedBox(height: 8),
//               _buildTextField(
//                 controller: firstName,
//                 label: "First Name",
//                 hint: "Enter your first name",
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: lastName,
//                 label: "Last Name",
//                 hint: "Enter your last name",
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: streetAddress,
//                 label: "Street Address",
//                 hint: "123 Main Street",
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: city,
//                 label: "City",
//                 hint: "Your city",
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: country,
//                 label: "Country",
//                 hint: "Your country",
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: postcode,
//                 label: "Postcode",
//                 hint: "123456",
//                 keyboardType: TextInputType.number,
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: email,
//                 label: "Email Address",
//                 hint: "you@example.com",
//                 keyboardType: TextInputType.emailAddress,
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: phone,
//                 label: "Phone Number",
//                 hint: "9876543210",
//                 keyboardType: TextInputType.phone,
//                 isTablet: isTablet,
//               ),
//
//               const SizedBox(height: 24),
//               _orderSummaryCard(isTablet),
//
//               const SizedBox(height: 16),
//               _buildPaymentMethodSelector(isTablet),
//
//               if (selectedPaymentMethod == 0) ...[
//                 const SizedBox(height: 12),
//                 _buildQRCodeSection(isTablet),
//               ] else ...[
//                 const SizedBox(height: 12),
//                 _buildRazorpayInfo(isTablet),
//               ],
//
//               const SizedBox(height: 24),
//               _otherPayments(isTablet),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//
//       bottomNavigationBar: SafeArea(
//         child: Obx(() {
//           final busy = chekoutController.isLoading.value;
//           final amount = getTotalAmount();
//
//           return Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//             child: SizedBox(
//               height: isTablet ? 56 : 52,
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: busy ? null : _submit,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 2,
//                 ),
//                 child: busy
//                     ? const SizedBox(
//                   width: 22,
//                   height: 22,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor:
//                     AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                     : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       selectedPaymentMethod == 0
//                           ? "Place Order (QR/UTR) • ₹$amount"
//                           : "Pay with Razorpay • ₹$amount",
//                       style: GoogleFonts.lato(
//                         fontSize: isTablet ? 18 : 16,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     const Icon(Icons.arrow_forward, color: Colors.white),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   // ---------- UI Builders ----------
//
//   Widget _sectionTitle(String text, bool isTablet) => Text(
//     text,
//     style: GoogleFonts.lato(
//       fontSize: isTablet ? 20 : 18,
//       fontWeight: FontWeight.bold,
//       color: AppColors.textPrimary,
//     ),
//   );
//
//   Widget _orderSummaryCard(bool isTablet) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(isTablet ? 20 : 16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Order Summary",
//               style: GoogleFonts.lato(
//                 fontSize: isTablet ? 18 : 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               )),
//           SizedBox(height: isTablet ? 12 : 8),
//
//           ...widget.cartItems.map((item) {
//             final lineAmount = (item.totalPrice ?? 0) * (item.quantity ?? 0);
//             return Padding(
//               padding: EdgeInsets.only(bottom: isTablet ? 8 : 6),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       item.courseName ?? 'Course',
//                       style: GoogleFonts.lato(
//                         fontSize: isTablet ? 16 : 14,
//                         color: AppColors.textPrimary,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Text(
//                     "₹$lineAmount",
//                     style: GoogleFonts.lato(
//                       fontSize: isTablet ? 16 : 14,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//
//           const Divider(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Total:",
//                   style: GoogleFonts.lato(
//                       fontSize: isTablet ? 18 : 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary)),
//               Text("₹${getTotalAmount()}",
//                   style: GoogleFonts.lato(
//                       fontSize: isTablet ? 18 : 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaymentMethodSelector(bool isTablet) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Select Payment Method",
//               style: TextStyle(
//                   fontSize: isTablet ? 18 : 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _selectTile(
//                   isActive: selectedPaymentMethod == 0,
//                   icon: Icons.qr_code,
//                   title: "QR Code / UPI",
//                   subtitle: "Upload Screenshot",
//                   onTap: () => setState(() => selectedPaymentMethod = 0),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _selectTile(
//                   isActive: selectedPaymentMethod == 1,
//                   icon: Icons.credit_card,
//                   title: "Razorpay",
//                   subtitle: "Cards / UPI / Wallets",
//                   onTap: () => setState(() => selectedPaymentMethod = 1),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _selectTile({
//     required bool isActive,
//     required IconData? icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color:
//           isActive ? AppColors.primary.withOpacity(0.07) : Colors.grey[50],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: isActive ? AppColors.primary : Colors.grey.shade300,
//               width: 2),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: AppColors.primary, size: 28),
//             const SizedBox(height: 8),
//             Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//             const SizedBox(height: 2),
//             Text(subtitle,
//                 style: const TextStyle(fontSize: 12, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQRCodeSection(bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 16 : 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 18.0),
//             child: Container(
//               height: 180,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(color: AppColors.primary),
//               ),
//               child: Image.asset(
//                 "assets/images/scannerimage.jpg",
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           _buildTextField(
//             controller: utrController,
//             label: "UTR Number",
//             hint: "Enter UTR number from payment",
//             isTablet: isTablet,
//             isRequired: true,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Payment Screenshot",
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: isTablet ? 16 : 14,
//             ),
//           ),
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: () async {
//               final XFile? img =
//               await ImagePicker().pickImage(source: ImageSource.gallery);
//               if (img != null) setState(() => selectedImage = img);
//             },
//             child: Container(
//               height: 140,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: selectedImage == null
//                   ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Icon(Icons.cloud_upload, size: 36, color: Colors.grey),
//                   SizedBox(height: 6),
//                   Text(
//                     "Tap to upload payment screenshot",
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               )
//                   : ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.file(
//                   File(selectedImage!.path),
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRazorpayInfo(bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 16 : 14),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue[100]!),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.info, color: Colors.blue),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               "Secure Razorpay Payment\nPay via Cards, UPI, Netbanking, or Wallets on Razorpay’s checkout.",
//               style: TextStyle(
//                 fontSize: isTablet ? 15 : 14,
//                 color: Colors.blue[800],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _otherPayments(bool isTablet) {
//     return Column(
//       children: [
//         const Divider(),
//         const SizedBox(height: 12),
//         Text(
//           'Other Payment Methods',
//           style: GoogleFonts.lato(
//             fontSize: isTablet ? 16 : 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 10),
//         OutlinedButton.icon(
//           onPressed: () => showPaymentDialog(context, isTablet),
//           icon: Icon(Icons.qr_code, color: AppColors.primary),
//           label: Text(
//             "Pay via UPI QR Code",
//             style: GoogleFonts.lato(
//               fontSize: isTablet ? 16 : 14,
//               color: AppColors.primary,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           style: OutlinedButton.styleFrom(
//             minimumSize: Size(double.infinity, isTablet ? 50 : 46),
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             side: BorderSide(color: AppColors.primary),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void showPaymentDialog(BuildContext context, bool isTablet) {
//     const String upiId = "9413561917@apl";
//
//     showCupertinoDialog(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setSt) {
//             return CupertinoAlertDialog(
//               title: Text(
//                 "Complete Payment",
//                 style: GoogleFonts.lato(
//                   fontSize: isTablet ? 20 : 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(height: isTablet ? 16 : 10),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.asset(
//                         'assets/images/scannerimage.jpg',
//                         height: isTablet ? 240 : 200,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     SizedBox(height: isTablet ? 16 : 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "UPI ID: $upiId",
//                           style: GoogleFonts.lato(
//                             fontSize: isTablet ? 18 : 16,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         SizedBox(width: isTablet ? 12 : 8),
//                         CupertinoButton(
//                           padding: EdgeInsets.zero,
//                           child: Icon(
//                             Icons.copy,
//                             size: isTablet ? 24 : 20,
//                             color: AppColors.primary,
//                           ),
//                           onPressed: () {
//                             Clipboard.setData(
//                               const ClipboardData(text: upiId),
//                             );
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   "UPI ID copied",
//                                   style: GoogleFonts.lato(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 backgroundColor: AppColors.primary,
//                                 duration: const Duration(seconds: 2),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: isTablet ? 16 : 10),
//                     CupertinoTextField(
//                       controller: utrController,
//                       placeholder: "Enter 10-16 digit UTR or transaction ID",
//                       placeholderStyle: GoogleFonts.lato(
//                         color: Colors.grey[400],
//                         fontSize: isTablet ? 16 : 14,
//                       ),
//                       keyboardType: TextInputType.number,
//                       padding: EdgeInsets.all(isTablet ? 16 : 12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: isTablet ? 16 : 10),
//                     CupertinoButton.filled(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isTablet ? 24 : 16,
//                         vertical: isTablet ? 12 : 10,
//                       ),
//                       child: Text(
//                         selectedImage == null
//                             ? "Upload Payment Screenshot"
//                             : "Change Payment Screenshot",
//                         style: GoogleFonts.lato(
//                           fontSize: isTablet ? 16 : 15,
//                           color: Colors.white,
//                         ),
//                       ),
//                       onPressed: () async {
//                         final XFile? img = await ImagePicker()
//                             .pickImage(source: ImageSource.gallery);
//                         if (img != null) setSt(() => selectedImage = img);
//                       },
//                     ),
//                     SizedBox(height: isTablet ? 12 : 8),
//                     if (selectedImage != null)
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.file(
//                             File(selectedImage!.path),
//                             height: isTablet ? 120 : 100,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 CupertinoDialogAction(
//                   isDestructiveAction: true,
//                   onPressed: () => Navigator.pop(context),
//                   child: Text(
//                     "Cancel",
//                     style: GoogleFonts.lato(
//                       fontSize: isTablet ? 16 : 14,
//                       color: CupertinoColors.destructiveRed,
//                     ),
//                   ),
//                 ),
//                 CupertinoDialogAction(
//                   isDefaultAction: true,
//                   onPressed: () async {
//                     if (utrController.text.isEmpty || selectedImage == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             "Please enter UTR and upload payment screenshot",
//                             style:
//                             GoogleFonts.lato(color: Colors.white),
//                           ),
//                           backgroundColor: Colors.red,
//                           duration: const Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     }
//                     if (utrController.text.length < 10 ||
//                         utrController.text.length > 16) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             "UTR must be 10-16 digits",
//                             style:
//                             GoogleFonts.lato(color: Colors.white),
//                           ),
//                           backgroundColor: Colors.red,
//                           duration: const Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     }
//                     await _submit();
//                   },
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Place Order",
//                         style: GoogleFonts.lato(
//                           fontSize: 14,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Icon(
//                         Icons.arrow_forward,
//                         color: AppColors.primary,
//                         size: 16,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     TextInputType keyboardType = TextInputType.text,
//     bool isRequired = true,
//     bool isTablet = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isTablet ? 20 : 16),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         validator: (value) {
//           if (isRequired && (value == null || value.trim().isEmpty)) {
//             return '$label is required';
//           }
//           if (keyboardType == TextInputType.emailAddress &&
//               value != null &&
//               value.isNotEmpty &&
//               !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//             return 'Enter a valid email address';
//           }
//           if (keyboardType == TextInputType.phone &&
//               value != null &&
//               value.isNotEmpty &&
//               value.length < 10) {
//             return 'Enter a valid phone number';
//           }
//           return null;
//         },
//         style: GoogleFonts.lato(
//           fontSize: isTablet ? 16 : 14,
//           color: AppColors.textPrimary,
//         ),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: GoogleFonts.lato(
//             color: Colors.grey[600],
//             fontSize: isTablet ? 16 : 14,
//           ),
//           hintText: hint,
//           hintStyle: GoogleFonts.lato(
//             color: Colors.grey[400],
//             fontSize: isTablet ? 16 : 14,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: EdgeInsets.symmetric(
//             vertical: isTablet ? 16 : 12,
//             horizontal: isTablet ? 20 : 16,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide:
//             const BorderSide(color: AppColors.primary, width: 2),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:auratech_academy/modules/Payment_module/Controller/Chekout_Cotroller.dart';
import 'package:auratech_academy/modules/Payment_module/Model/ChekoutModel.dart';
import 'package:auratech_academy/utils/logx.dart';
import 'package:auratech_academy/utils/storageservice.dart';
import 'package:auratech_academy/utils/util_klass.dart';
import 'package:auratech_academy/widget/custombottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/constant_colors.dart';
import '../../My_course_module/Model/My_Course_Model.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final ChekoutController chekoutController = Get.find();

  // Billing inputs
  final TextEditingController utrController = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController companyName = TextEditingController();
  final TextEditingController streetAddress = TextEditingController();
  final TextEditingController apartment = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController postcode = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  XFile? selectedImage;
  int selectedPaymentMethod = 0; // 0 = QR/UTR, 1 = Razorpay

  @override
  void initState() {
    super.initState();
    _prefillUserData();
    LogX.printLog(
        "🛒 Checkout initialized with ${widget.cartItems.length} cart items");
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    companyName.dispose();
    streetAddress.dispose();
    apartment.dispose();
    city.dispose();
    country.dispose();
    postcode.dispose();
    email.dispose();
    phone.dispose();
    utrController.dispose();
    super.dispose();
  }

  // ---------- Helpers (Totals) ----------

  int getTotalAmount() {
    return widget.cartItems.fold(
      0,
      (sum, item) =>
          sum + ((item.totalPrice ?? 0) * (item.quantity ?? 0)).toInt(),
    );
  }

  int getTotalQty() {
    return widget.cartItems.fold(
      0,
      (sum, item) => sum + (item.quantity ?? 0),
    );
  }

  List<int> _cartIds() => widget.cartItems
      .map((e) => e.id)
      .whereType<int>()
      .where((id) => id > 0)
      .toList();

  void _prefillUserData() {
    final userEmail = StorageService.getData("email") ??
        StorageService.getData("Login Email");
    final userName = StorageService.getData("name") ?? "Student";

    if (userEmail != null) email.text = userEmail;
    final parts = userName.split(' ');
    if (parts.isNotEmpty) firstName.text = parts[0];
    if (parts.length > 1) lastName.text = parts.sublist(1).join(' ');
  }

  void _clearForm() {
    firstName.clear();
    lastName.clear();
    companyName.clear();
    streetAddress.clear();
    apartment.clear();
    city.clear();
    country.clear();
    postcode.clear();
    email.clear();
    phone.clear();
    utrController.clear();
    selectedImage = null;
    setState(() {});
  }

  // ---------- Build order_details from cartItems ----------

  List<OrderDetailCreateModel> _buildOrderDetails({
    required int createUser,
    required int updateUser,
  }) {
    return widget.cartItems.map((item) {
      final int qty = item.quantity ?? 1;

      // ⚠️ Yahan tum apne CartItem ke actual field names use karo:
      // e.g. item.price, item.courseId, item.subscriptionId, etc.
      final double unitPrice =
          (item.totalPrice ?? 0); // agar totalPrice already per unit nahi hai
      final double lineTotal = unitPrice * qty;

      return OrderDetailCreateModel(
        course_id: item.courseId ?? 0,
        subscription_id: 1 ?? 0,
        qty: qty.toString(),
        Rate: unitPrice.toStringAsFixed(0),
        total_qty: qty.toString(),
        total_amt: lineTotal.toStringAsFixed(0),
        tax_type: "Interstate",
        igst: null,
        cgst: null,
        scgst: null,
        other_charges: null,
        discount_amt: null,
        net_amt: null,
        remarks: null,
        extra: null,
        create_user: createUser,
        update_user: updateUser,
      );
    }).toList();
  }

  // ---------- Order master API helper ----------

  Future<bool> _createOrderOnServer({
    required String paymentMode,
    required String paymentResponse,
    required bool paymentStatus,
  }) async {
    final int userId = StorageService.getData("User_id") ?? 0;
    final int totalAmount = getTotalAmount();
    final int totalQty = getTotalQty();
    final String nowUtc = DateTime.now().toUtc().toIso8601String();

    final String billingNameCombined =
        "${firstName.text.trim()} ${lastName.text.trim()}".trim();

    final String billingAddressCombined =
        "${streetAddress.text.trim()}, ${city.text.trim()}, ${country.text.trim()} - ${postcode.text.trim()}"
            .trim();


    const int creatorId = 1;

    final orderDetails = _buildOrderDetails(
      createUser: creatorId,
      updateUser: creatorId,
    );

    LogX.printLog(
        "🧮 [CheckoutScreen] total_qty=$totalQty, total_amt=$totalAmount, order_details=${orderDetails.length}");

    await chekoutController.createOrder(
      userId: userId,
      date: nowUtc,
      orderFrom: "App",
      itemCount: widget.cartItems.length.toString(),
      totalQty: totalQty.toString(),
      totalAmt: totalAmount.toString(),
      taxType: "Interstate",
      igst: "10",
      cgst: null,
      scgst: null,
      otherCharges: "40",
      discountAmt: "20",
      couponCode: "AURA10",
      netAmt: totalAmount.toString(),
      billingName: billingNameCombined,
      billingAddress: billingAddressCombined,
      gstType: "CGST",
      gstStateCode: "18",
      description:
          "Course purchase (${widget.cartItems.length} items) via $paymentMode",
      orderStatus: paymentStatus,
      paymentMode: paymentMode,
      paymentResponse: paymentResponse,
      paymentStatus: paymentStatus,
      remarks: null,
      extra: null,
      // createUser: creatorId,
      // updateUser: creatorId,
      orderDetails: orderDetails,
    );

    if (chekoutController.errorMessage.isNotEmpty) {
      UtilKlass.showToastMsg(
        "Failed to place order: ${chekoutController.errorMessage.value}",
        context,
      );
      return false;
    }

    return true;
  }

  // ---------- Submit Flow ----------

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ids = _cartIds();
    if (ids.isEmpty) {
      Get.snackbar('Error', 'Invalid cart items',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    String paymentMode;
    String paymentResponse;
    bool paymentStatus;

    if (selectedPaymentMethod == 0) {
      // QR/UTR route
      if (selectedImage == null || utrController.text.trim().isEmpty) {
        Get.snackbar('Missing info', 'Please enter UTR & upload screenshot',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      if (utrController.text.length < 10 || utrController.text.length > 16) {
        Get.snackbar('Invalid UTR', 'UTR must be 10–16 characters',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      paymentMode = "CASH";
      paymentResponse =
          "Payment pending verification (UTR: ${utrController.text.trim()})";
      paymentStatus = false; // admin verify karega
    } else {
      // Razorpay route – abhi direct meta store
      paymentMode = "RAZORPAY";
      paymentResponse = "Razorpay payment initiated";
      paymentStatus = true;
    }

    final ok = await _createOrderOnServer(
      paymentMode: paymentMode,
      paymentResponse: paymentResponse,
      paymentStatus: paymentStatus,
    );

    if (!ok) return;

    _clearForm();
    UtilKlass.showToastMsg("Order Placed Successfully", context);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomnavBar()),
      );
    }
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: GoogleFonts.lato(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: isTablet ? 28 : 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Billing Details", isTablet),
              const SizedBox(height: 8),
              _buildTextField(
                controller: firstName,
                label: "First Name",
                hint: "Enter your first name",
                isTablet: isTablet,
              ),
              _buildTextField(
                controller: lastName,
                label: "Last Name",
                hint: "Enter your last name",
                isTablet: isTablet,
              ),
              _buildTextField(
                controller: streetAddress,
                label: "Street Address",
                hint: "123 Main Street",
                isTablet: isTablet,
              ),
              _buildTextField(
                controller: city,
                label: "City",
                hint: "Your city",
                isTablet: isTablet,
              ),
              _buildTextField(
                controller: country,
                label: "Country",
                hint: "Your country",
                isTablet: isTablet,
              ),
              _buildTextField(
                controller: postcode,
                label: "Postcode",
                hint: "123456",
                keyboardType: TextInputType.number,
                isTablet: isTablet,
              ),
              _buildTextField(
                controller: email,
                label: "Email Address",
                hint: "abc@gmail.com",
                keyboardType: TextInputType.emailAddress,
                isTablet: isTablet,
              ),
              _buildTextField(
                controller: phone,
                label: "Phone Number",
                hint: "9876543210",
                keyboardType: TextInputType.phone,
                isTablet: isTablet,
              ),
              const SizedBox(height: 24),
              _orderSummaryCard(isTablet),
              const SizedBox(height: 16),
              _buildPaymentMethodSelector(isTablet),
              if (selectedPaymentMethod == 0) ...[
                const SizedBox(height: 12),
                _buildQRCodeSection(isTablet),
              ] else ...[
                const SizedBox(height: 12),
                _buildRazorpayInfo(isTablet),
              ],
              const SizedBox(height: 24),
              _otherPayments(isTablet),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(() {
          final busy = chekoutController.isLoading.value;
          final amount = getTotalAmount();

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              height: isTablet ? 56 : 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: busy ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedPaymentMethod == 0
                                ? "Place Order (QR/UTR) • ₹$amount"
                                : "Pay with Razorpay • ₹$amount",
                            style: GoogleFonts.lato(
                              fontSize: isTablet ? 18 : 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------- UI Helpers ----------

  Widget _sectionTitle(String text, bool isTablet) => Text(
        text,
        style: GoogleFonts.lato(
          fontSize: isTablet ? 20 : 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      );

  Widget _orderSummaryCard(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Summary",
              style: GoogleFonts.lato(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              )),
          SizedBox(height: isTablet ? 12 : 8),
          ...widget.cartItems.map((item) {
            final lineAmount = (item.totalPrice ?? 0) * (item.quantity ?? 0);
            return Padding(
              padding: EdgeInsets.only(bottom: isTablet ? 8 : 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.courseName ?? 'Course',
                      style: GoogleFonts.lato(
                        fontSize: isTablet ? 16 : 14,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "₹$lineAmount",
                    style: GoogleFonts.lato(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total:",
                  style: GoogleFonts.lato(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              Text("₹${getTotalAmount()}",
                  style: GoogleFonts.lato(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector(bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Payment Method",
              style: TextStyle(
                  fontSize: isTablet ? 18 : 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _selectTile(
                  isActive: selectedPaymentMethod == 0,
                  icon: Icons.qr_code,
                  title: "QR Code / UPI",
                  subtitle: "Upload Screenshot",
                  onTap: () => setState(() => selectedPaymentMethod = 0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _selectTile(
                  isActive: selectedPaymentMethod == 1,
                  icon: Icons.credit_card,
                  title: "Razorpay",
                  subtitle: "Cards / UPI / Wallets",
                  onTap: () => setState(() => selectedPaymentMethod = 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectTile({
    required bool isActive,
    required IconData? icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isActive ? AppColors.primary.withOpacity(0.07) : Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isActive ? AppColors.primary : Colors.grey.shade300,
              width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeSection(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.primary),
              ),
              child: Image.asset(
                "assets/images/scannerimage.jpg",
                fit: BoxFit.contain,
              ),
            ),
          ),
          _buildTextField(
            controller: utrController,
            label: "UTR Number",
            hint: "Enter UTR number from payment",
            isTablet: isTablet,
            isRequired: true,
          ),
          const SizedBox(height: 8),
          Text(
            "Payment Screenshot",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 16 : 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final XFile? img =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (img != null) setState(() => selectedImage = img);
            },
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: selectedImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cloud_upload, size: 36, color: Colors.grey),
                        SizedBox(height: 6),
                        Text(
                          "Tap to upload payment screenshot",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(selectedImage!.path),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRazorpayInfo(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Secure Razorpay Payment\nPay via Cards, UPI, Netbanking, or Wallets on Razorpay’s checkout.",
              style: TextStyle(
                fontSize: isTablet ? 15 : 14,
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherPayments(bool isTablet) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 12),
        Text(
          'Other Payment Methods',
          style: GoogleFonts.lato(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => showPaymentDialog(context, isTablet),
          icon: Icon(Icons.qr_code, color: AppColors.primary),
          label: Text(
            "Pay via UPI QR Code",
            style: GoogleFonts.lato(
              fontSize: isTablet ? 16 : 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, isTablet ? 50 : 46),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  void showPaymentDialog(BuildContext context, bool isTablet) {
    const String upiId = "9413561917@apl";

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSt) {
            return CupertinoAlertDialog(
              title: Text(
                "Complete Payment",
                style: GoogleFonts.lato(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: isTablet ? 16 : 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/scannerimage.jpg',
                        height: isTablet ? 240 : 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "UPI ID: $upiId",
                          style: GoogleFonts.lato(
                            fontSize: isTablet ? 18 : 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: isTablet ? 12 : 8),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            Icons.copy,
                            size: isTablet ? 24 : 20,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              const ClipboardData(text: upiId),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "UPI ID copied",
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppColors.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 16 : 10),
                    CupertinoTextField(
                      controller: utrController,
                      placeholder: "Enter 10-16 digit UTR or transaction ID",
                      placeholderStyle: GoogleFonts.lato(
                        color: Colors.grey[400],
                        fontSize: isTablet ? 16 : 14,
                      ),
                      keyboardType: TextInputType.number,
                      padding: EdgeInsets.all(isTablet ? 16 : 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 10),
                    CupertinoButton.filled(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 16,
                        vertical: isTablet ? 12 : 10,
                      ),
                      child: Text(
                        selectedImage == null
                            ? "Upload Payment Screenshot"
                            : "Change Payment Screenshot",
                        style: GoogleFonts.lato(
                          fontSize: isTablet ? 16 : 15,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        final XFile? img = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (img != null) setSt(() => selectedImage = img);
                      },
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    if (selectedImage != null)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(selectedImage!.path),
                            height: isTablet ? 120 : 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.lato(
                      fontSize: isTablet ? 16 : 14,
                      color: CupertinoColors.destructiveRed,
                    ),
                  ),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    if (utrController.text.isEmpty || selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please enter UTR and upload payment screenshot",
                            style: GoogleFonts.lato(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    if (utrController.text.length < 10 ||
                        utrController.text.length > 16) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "UTR must be 10-16 digits",
                            style: GoogleFonts.lato(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    await _submit();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Place Order",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
    bool isTablet = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }
          if (keyboardType == TextInputType.emailAddress &&
              value != null &&
              value.isNotEmpty &&
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Enter a valid email address';
          }
          if (keyboardType == TextInputType.phone &&
              value != null &&
              value.isNotEmpty &&
              value.length < 10) {
            return 'Enter a valid phone number';
          }
          return null;
        },
        style: GoogleFonts.lato(
          fontSize: isTablet ? 16 : 14,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.lato(
            color: Colors.grey[600],
            fontSize: isTablet ? 16 : 14,
          ),
          hintText: hint,
          hintStyle: GoogleFonts.lato(
            color: Colors.grey[400],
            fontSize: isTablet ? 16 : 14,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: isTablet ? 16 : 12,
            horizontal: isTablet ? 20 : 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}

/// new screen code end ///
