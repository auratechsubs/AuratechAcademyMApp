// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import '../../../constant/constant_colors.dart';
// import '../../../utils/storageservice.dart';
// import '../../../utils/util_klass.dart';
// import '../../../widget/custombottombar.dart';
// import '../../My_course_module/Model/My_Course_Model.dart';
// import '../Controller/Chekout_Cotroller.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   final List<CartItem> cartItems;
//
//   const CheckoutScreen({super.key, required this.cartItems});
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final ChekoutController chekoutController = Get.find();
//   late Razorpay _razorpay;
//
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
//   XFile? selectedImage;
//
//   int selectedPaymentMethod = 0; // 0 = QR Code, 1 = Razorpay
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
//     _razorpay.clear();
//
//     super.dispose();
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
//             borderSide: const BorderSide(color: AppColors.primary, width: 2),
//           ),
//         ),
//       ),
//     );
//   }
//
//   int getTotalAmount() {
//     return widget.cartItems.fold(
//       0,
//       (sum, item) =>
//           sum + ((item.totalPrice ?? 0) * (item.quantity ?? 0)).toInt(),
//     );
//   }
//
//   Future<void> placeOrder() async {
//     chekoutController.isLoading.value = true;
//
//     try {
//       List<int> cartitemIds = widget.cartItems
//           .map((item) => item.id)
//           .whereType<int>()
//           .where((id) => id > 0)
//           .toList();
//
//       print("cart items ids => $cartitemIds");
//
//       if (cartitemIds.isEmpty) {
//         Get.snackbar(
//           "Error",
//           "Invalid cart items. Please try again.",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.TOP,
//         );
//         return;
//       }
//
//       // await chekoutController.checkout(
//       //   userId: StorageService.getData("User_id"),
//       //   cartitemIds: cartitemIds,
//       //   firstName: firstName.text.trim(),
//       //   lastName: lastName.text.trim(),
//       //   countryName: country.text.trim(),
//       //   companyName: companyName.text.trim(),
//       //   streetAddress: streetAddress.text.trim(),
//       //   apartmentNo: apartment.text.trim(),
//       //   cityName: city.text.trim(),
//       //   postCode: postcode.text.trim(),
//       //   emailAddress: email.text.trim(),
//       //   phoneNumber: phone.text.trim(),
//       //   paymentScreenshot:
//       //       selectedImage != null ? File(selectedImage!.path) : null,
//       //   utr_no: utrController.text.trim(),
//       // );
//
//       UtilKlass.showToastMsg("Order Placed Successfully", context);
//
//       firstName.clear();
//       lastName.clear();
//       companyName.clear();
//       streetAddress.clear();
//       apartment.clear();
//       city.clear();
//       country.clear();
//       postcode.clear();
//       email.clear();
//       phone.clear();
//       utrController.clear();
//       selectedImage = null;
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Failed to place order: $e",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.TOP,
//       );
//     } finally {
//       chekoutController.isLoading.value = false;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     _prefillUserData();
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     chekoutController.placeOrderAfterPayment(response.paymentId!);
//   }
//
//
//
//
//   void _prefillUserData() {
//     final userEmail = StorageService.getData("email") ?? StorageService.getData("Login Email");
//     final userName = StorageService.getData("name") ?? "Student";
//
//     if (userEmail != null) email.text = userEmail;
//
//     final nameParts = userName.split(' ');
//     if (nameParts.isNotEmpty) firstName.text = nameParts[0];
//     if (nameParts.length > 1) lastName.text = nameParts.sublist(1).join(' ');
//   }
//
//
//   // void _handlePaymentError(PaymentFailureResponse response) {
//   //   Get.snackbar(
//   //     'Payment Failed',
//   //     'Error: ${response.code} - ${response.message}',
//   //     backgroundColor: Colors.red,
//   //     colorText: Colors.white,
//   //   );
//   // }
//   //
//   // void _handleExternalWallet(ExternalWalletResponse response) {
//   //   Get.snackbar(
//   //     'External Wallet',
//   //     'Wallet: ${response.walletName}',
//   //     backgroundColor: Colors.orange,
//   //     colorText: Colors.white,
//   //   );
//   // }
//   //
//   //
//   void _openRazorpayCheckout(bool isTablet , String prefillnumber, String prefilemail) {
//     final totalAmount =
//         getTotalAmount();
//
//     final options = {
//       'key': 'rzp_test_RYPjmxVz9OvnOa',
//       'amount': (totalAmount * 100).round(),
//        'name': 'AuraTech Academy',
//       'description': 'Course Enrollment',
//       'prefill': {'contact': '7419265803', 'email': 'khansohil87078@gmail.com'},
//       'method': {
//         'netbanking': true,
//         'card': true,
//         'upi': true,
//         'wallet': true,
//       },
//       'external': {
//         'wallets': ['paytm', 'phonepe', 'google_pay']
//       },
//       'upi': {
//         'flow': 'collect'
//       }
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e');
//        ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//
//
//   ///new method
// //   Future<void> placeOrderWithQRCode() async {
// //     if (!_formKey.currentState!.validate()) {
// //       return;
// //     }
// //
// //     if (selectedPaymentMethod == 0 && selectedImage == null) {
// //       Get.snackbar(
// //         "Error",
// //         "Please upload payment screenshot",
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //       return;
// //     }
// //
// //     chekoutController.isLoading.value = true;
// //
// //     try {
// //       List<int> cartitemIds = widget.cartItems
// //           .map((item) => item.id ?? 0)
// //           .where((id) => id > 0)
// //           .toList();
// //
// //       if (cartitemIds.isEmpty) {
// //         Get.snackbar(
// //           "Error",
// //           "Invalid cart items. Please try again.",
// //           backgroundColor: Colors.red,
// //           colorText: Colors.white,
// //         );
// //         return;
// //       }
// //
// //       await chekoutController.checkout(
// //         userId: StorageService.getData("User_id") ?? 1,
// //         cartitemIds: cartitemIds,
// //         firstName: firstName.text.trim(),
// //         lastName: lastName.text.trim(),
// //         countryName: country.text.trim(),
// //         companyName: companyName.text.trim(),
// //         streetAddress: streetAddress.text.trim(),
// //         apartmentNo: apartment.text.trim(),
// //         cityName: city.text.trim(),
// //         postCode: postcode.text.trim(),
// //         emailAddress: email.text.trim(),
// //         phoneNumber: phone.text.trim(),
// //         paymentScreenshot: selectedImage != null ? File(selectedImage!.path) : null,
// //         utr_no: utrController.text.trim(),
// //       );
// //
// //       // Clear form after success
// //       _clearForm();
// //
// //     } catch (e) {
// //       Get.snackbar(
// //         "Error",
// //         "Failed to place order: $e",
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //     } finally {
// //       chekoutController.isLoading.value = false;
// //     }
// //   }
// //
// // // ✅ METHOD 2: Razorpay Payment
// //   void _proceedToRazorpayPayment() {
// //     if (!_formKey.currentState!.validate()) {
// //       return;
// //     }
// //
// //     // Set order details for Razorpay
// //     chekoutController.setOrderDetails(
// //       userId: StorageService.getData("User_id") ?? 1,
// //       cartitemIds: widget.cartItems
// //           .map((item) => item.id ?? 0)
// //           .where((id) => id > 0)
// //           .toList(),
// //       firstName: firstName.text.trim(),
// //       lastName: lastName.text.trim(),
// //       countryName: country.text.trim(),
// //       companyName: companyName.text.trim(),
// //       streetAddress: streetAddress.text.trim(),
// //       apartmentNo: apartment.text.trim(),
// //       cityName: city.text.trim(),
// //       postCode: postcode.text.trim(),
// //       emailAddress: email.text.trim(),
// //       phoneNumber: phone.text.trim(),
// //       totalAmount: getTotalAmount().toDouble(),
// //       courseName: widget.cartItems.map((e) => e.courseName ?? "Course").join(', '),
// //     );
// //
// //     // Initiate Razorpay payment
// //     chekoutController.initiateRazorpayPayment(phone.text.trim(), email.text.trim());
// //   }
//
//
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     Get.snackbar(
//       'Payment Failed',
//       'Error: ${response.code} - ${response.message}',
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Get.snackbar(
//       'External Wallet',
//       'Wallet: ${response.walletName}',
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//     );
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
//

//   Widget _buildPaymentMethodSelector(bool isTablet) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 20),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Select Payment Method",
//             style: TextStyle(
//               fontSize: isTablet ? 18 : 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 12),
//           Row(
//             children: [
//               // QR Code Option
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedPaymentMethod = 0;
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: selectedPaymentMethod == 0 ? AppColors.primary.withOpacity(0.1) : Colors.grey[50],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: selectedPaymentMethod == 0 ? AppColors.primary : Colors.grey.shade300,
//                         width: 2,
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Icon(Icons.qr_code, color: AppColors.primary, size: 32),
//                         SizedBox(height: 8),
//                         Text(
//                           "QR Code / UPI",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         Text(
//                           "Upload Screenshot",
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               // Razorpay Option
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedPaymentMethod = 1;
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: selectedPaymentMethod == 1 ? AppColors.primary.withOpacity(0.1) : Colors.grey[50],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: selectedPaymentMethod == 1 ? AppColors.primary : Colors.grey.shade300,
//                         width: 2,
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Icon(Icons.credit_card, color: AppColors.primary, size: 32),
//                         SizedBox(height: 8),
//                         Text(
//                           "Razorpay",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         Text(
//                           "Cards/UPI/Wallets",
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQRCodeSection(bool isTablet) {
//     if (selectedPaymentMethod != 0) return SizedBox();
//
//     return Column(
//       children: [
//         // UTR Number Field
//         _buildTextField(
//           controller: utrController,
//           label: "UTR Number",
//           hint: "Enter UTR number from payment",
//           isTablet: isTablet,
//           isRequired: true,
//         ),
//
//         // Screenshot Upload
//         Container(
//           margin: EdgeInsets.only(bottom: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Payment Screenshot",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//               ),
//               SizedBox(height: 8),
//               GestureDetector(
//                 onTap: () async {
//                   final ImagePicker picker = ImagePicker();
//                   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//                   if (image != null) {
//                     setState(() {
//                       selectedImage = image;
//                     });
//                   }
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.grey[50],
//                   ),
//                   child: selectedImage == null
//                       ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
//                       Text("Tap to upload payment screenshot"),
//                     ],
//                   )
//                       : Image.file(File(selectedImage!.path), fit: BoxFit.cover),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRazorpayInfo(bool isTablet) {
//     if (selectedPaymentMethod != 1) return SizedBox();
//
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.blue[100]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.info, color: Colors.blue, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 "Secure Razorpay Payment",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             "You'll be redirected to Razorpay's secure payment gateway to complete your payment using cards, UPI, or wallets.",
//             style: TextStyle(fontSize: 14, color: Colors.blue[700]),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
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
//           icon: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: AppColors.textPrimary,
//             size: isTablet ? 28 : 24,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isTablet ? 24 : 16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Billing Details",
//                 style: GoogleFonts.lato(
//                   fontSize: isTablet ? 20 : 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               SizedBox(height: isTablet ? 16 : 12),
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
//                 controller: companyName,
//                 label: "Company Name",
//                 hint: "Enter your company name",
//                 isRequired: false,
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: streetAddress,
//                 label: "Street Address",
//                 hint: "123 Main Street",
//                 isTablet: isTablet,
//               ),
//               _buildTextField(
//                 controller: apartment,
//                 label: "Apartment No.",
//                 hint: "Apt 3B",
//                 isRequired: false,
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
//               SizedBox(height: isTablet ? 32 : 24),
//
//               // Cart Summary
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(isTablet ? 20 : 16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.white,
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Order Summary",
//                       style: GoogleFonts.lato(
//                         fontSize: isTablet ? 18 : 16,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     SizedBox(height: isTablet ? 12 : 8),
//                     ...widget.cartItems.map((item) => Padding(
//                           padding: EdgeInsets.only(bottom: isTablet ? 6 : 4),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "${item.courseName}",
//                                   style: GoogleFonts.lato(
//                                     fontSize: isTablet ? 16 : 14,
//                                     color: AppColors.textPrimary,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Text(
//                                 "₹${(item.totalPrice ?? 0) * (item.quantity ?? 0)}",
//                                 style: GoogleFonts.lato(
//                                   fontSize: isTablet ? 16 : 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColors.textPrimary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )),
//                     const Divider(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Total:",
//                           style: GoogleFonts.lato(
//                             fontSize: isTablet ? 18 : 16,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         Text(
//                           "₹${getTotalAmount()}",
//                           style: GoogleFonts.lato(
//                             fontSize: isTablet ? 18 : 16,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: isTablet ? 32 : 24),
//
//               // Place Order Button
//               // Obx(() => ElevatedButton(
//               //       onPressed: chekoutController.isLoading.value
//               //           ? null
//               //           : () {
//               //               if (_formKey.currentState?.validate() ?? false) {
//               //                 showPaymentDialog(context, isTablet);
//               //               }
//               //             },
//               //       style: ElevatedButton.styleFrom(
//               //         backgroundColor: AppColors.primary,
//               //         minimumSize: Size(double.infinity, isTablet ? 56 : 50),
//               //         shape: RoundedRectangleBorder(
//               //           borderRadius: BorderRadius.circular(12),
//               //         ),
//               //         elevation: 2,
//               //       ),
//               //       child: chekoutController.isLoading.value
//               //           ? const SizedBox(
//               //               width: 24,
//               //               height: 24,
//               //               child: CircularProgressIndicator(
//               //                 strokeWidth: 2,
//               //                 valueColor: AlwaysStoppedAnimation(Colors.white),
//               //               ),
//               //             )
//               //           : Row(
//               //         mainAxisAlignment: MainAxisAlignment.center,
//               //               children: [
//               //                 Text(
//               //                   "Place Order",
//               //                   style: GoogleFonts.lato(
//               //                     fontSize: isTablet ? 18 : 16,
//               //                     color: Colors.white,
//               //                     fontWeight: FontWeight.bold,
//               //                   ),
//               //                 ),SizedBox(width: 10,),Icon(Icons.arrow_forward,color: Colors.white,size: isTablet ? 18 : 16 ,)
//               //               ],
//               //             ),
//               //     )),
//
//               Obx(() => ElevatedButton(
//                     onPressed: chekoutController.isLoading.value
//                         ? null
//                         : () {
//                             if (_formKey.currentState?.validate() ?? false) {
//                               _openRazorpayCheckout(isTablet, phone.text.trim(), email.text.trim());
//                             }
//                           },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       minimumSize: Size(double.infinity, isTablet ? 56 : 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: chekoutController.isLoading.value
//                         ? SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation(Colors.white),
//                             ),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Pay with Razorpay",
//                                 style: GoogleFonts.lato(
//                                   fontSize: isTablet ? 18 : 16,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Icon(
//                                 Icons.arrow_forward,
//                                 color: Colors.white,
//                                 size: isTablet ? 18 : 16,
//                               )
//                             ],
//                           ),
//                   )),
//
//
//
//                SizedBox(height: 16),
//
//               // Alternative payment methods
//               _buildAlternativePaymentMethods(isTablet),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   // Widget _buildButtonChild(bool isTablet) {
//   //   if (chekoutController.isLoading.value) {
//   //     return SizedBox(
//   //       width: 24,
//   //       height: 24,
//   //       child: CircularProgressIndicator(
//   //         strokeWidth: 2,
//   //         valueColor: AlwaysStoppedAnimation(Colors.white),
//   //       ),
//   //     );
//   //   }
//   //
//   //   if (chekoutController.isPaymentProcessing.value) {
//   //     return Row(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       children: [
//   //         Text(
//   //           "Processing Payment...",
//   //           style: TextStyle(fontSize: isTablet ? 16 : 14),
//   //         ),
//   //         SizedBox(width: 8),
//   //         SizedBox(
//   //           width: 16,
//   //           height: 16,
//   //           child: CircularProgressIndicator(
//   //             strokeWidth: 2,
//   //             valueColor: AlwaysStoppedAnimation(Colors.white),
//   //           ),
//   //         ),
//   //       ],
//   //     );
//   //   }
//   //
//   //   return Text(
//   //     selectedPaymentMethod == 0
//   //         ? "Place Order - ₹${getTotalAmount()}"
//   //         : "Pay with Razorpay - ₹${getTotalAmount()}",
//   //     style: TextStyle(
//   //       fontSize: isTablet ? 18 : 16,
//   //       fontWeight: FontWeight.bold,
//   //     ),
//   //   );
//   // }
//

//   Widget _buildAlternativePaymentMethods(bool isTablet) {
//     return Column(
//       children: [
//         Divider(),
//         SizedBox(height: 16),
//         Text(
//           'Other Payment Methods',
//           style: GoogleFonts.lato(
//             fontSize: isTablet ? 16 : 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         SizedBox(height: 12),
//         OutlinedButton(
//           onPressed: () {
//             // Fallback to your original UPI method if needed
//             showPaymentDialog(context, isTablet);
//           },
//           style: OutlinedButton.styleFrom(
//             minimumSize: Size(double.infinity, isTablet ? 50 : 44),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             side: BorderSide(color: AppColors.primary),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.qr_code, color: AppColors.primary),
//               SizedBox(width: 8),
//               Text(
//                 "Pay via UPI QR Code",
//                 style: GoogleFonts.lato(
//                   fontSize: isTablet ? 16 : 14,
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//

//   void showPaymentDialog(BuildContext context, bool isTablet) {
//     final String upiId = "9413561917@apl";
//
//     showCupertinoDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
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
//                             Clipboard.setData(ClipboardData(text: upiId));
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   "UPI ID copied",
//                                   style: GoogleFonts.lato(color: Colors.white),
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
//                         final ImagePicker picker = ImagePicker();
//                         final XFile? image = await picker.pickImage(
//                           source: ImageSource.gallery,
//                         );
//                         if (image != null) {
//                           setState(() => selectedImage = image);
//                         }
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
//                             style: GoogleFonts.lato(color: Colors.white),
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
//                             style: GoogleFonts.lato(color: Colors.white),
//                           ),
//                           backgroundColor: Colors.red,
//                           duration: const Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     }
//                     await placeOrder();
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const BottomnavBar()),
//                     );
//                   },
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min, // 👈 Add this
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Place Order",
//                         style: GoogleFonts.lato(
//                           fontSize: 14,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Icon(
//                         Icons.arrow_forward,
//                         color: AppColors.primary,
//                         size: 14,
//                       )
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
// }

// checkout_screen.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../constant/constant_colors.dart';
import '../../../utils/storageservice.dart';
import '../../../utils/util_klass.dart';
import '../../../widget/custombottombar.dart';
import '../../My_course_module/Model/My_Course_Model.dart';
import '../Controller/Chekout_Cotroller.dart';

//  class OrderDraft {
//   final int userId;
//   final List<int> cartitemIds;
//   final String firstName;
//   final String lastName;
//   final String countryName;
//   final String companyName;
//   final String streetAddress;
//   final String apartmentNo;
//   final String cityName;
//   final String postCode;
//   final String emailAddress;
//   final String phoneNumber;
//   final int amountRupee;
//
//   const OrderDraft({
//     required this.userId,
//     required this.cartitemIds,
//     required this.firstName,
//     required this.lastName,
//     required this.countryName,
//     required this.companyName,
//     required this.streetAddress,
//     required this.apartmentNo,
//     required this.cityName,
//     required this.postCode,
//     required this.emailAddress,
//     required this.phoneNumber,
//     required this.amountRupee,
//   });
//
//   @override
//   String toString() {
//     return 'OrderDraft(userId:$userId, items:${cartitemIds.length}, amount:$amountRupee, name:$firstName $lastName, email:$emailAddress, phone:$phoneNumber)';
//   }
// }

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final ChekoutController chekoutController = Get.find();

  late Razorpay _razorpay;

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
    _razorpay =
        Razorpay(); // just to have an instance; callbacks handled in controller service
    _prefillUserData();
  }

  @override
  void dispose() {
    _razorpay.clear();
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

  // ---------- Helpers ----------

  int getTotalAmount() {
    return widget.cartItems.fold(
      0,
      (sum, item) =>
          sum + ((item.totalPrice ?? 0) * (item.quantity ?? 0)).toInt(),
    );
  }

  List<int> _cartIds() => widget.cartItems
      .map((e) => e.id)
      .whereType<int>()
      .where((id) => id > 0)
      .toList();

  OrderDraft _buildDraft() {
    final draft = OrderDraft(
      userId: StorageService.getData("User_id") ?? 0,
      cartitemIds: _cartIds(),
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
      countryName: country.text.trim(),
      companyName: companyName.text.trim(),
      streetAddress: streetAddress.text.trim(),
      apartmentNo: apartment.text.trim(),
      cityName: city.text.trim(),
      postCode: postcode.text.trim(),
      emailAddress: email.text.trim(),
      phoneNumber: phone.text.trim(),
      amountRupee: getTotalAmount(),
    );
    debugPrint("🧾 Draft => $draft");
    return draft;
  }

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

      final draft = _buildDraft();
      await chekoutController.checkoutWithQRCode(
        paymentScreenshot: File(selectedImage!.path),
        draft: draft,
        utrNo: utrController.text.trim(),
      );

      // If your controller sets a success flag, check it; here we just reset.
      _clearForm();
      UtilKlass.showToastMsg("Order Placed Successfully", context);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomnavBar()),
        );
      }
    } else {
      // Razorpay route
      final draft = _buildDraft();
      await chekoutController.startRazorpay(
        draft: draft,
        rzpKey: 'rzp_test_RYPjmxVz9OvnOa', // 🔑 test key
        createOrderOnServer:
            false, // set true when your backend /orders is ready
      );
      // On success your controller should internally call placeOrderAfterPayment()
      // and navigate or expose a signal to you. Keep UI idle here.
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

      // Keep body purely scrollable content (no Expanded here!)
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
                controller: companyName,
                label: "Company Name",
                hint: "Enter your company name",
                isRequired: false,
                isTablet: isTablet,
              ),
              _buildTextField(
                controller: streetAddress,
                label: "Street Address",
                hint: "123 Main Street",
                isTablet: isTablet,
              ),
              _buildTextField(
                controller: apartment,
                label: "Apartment No.",
                hint: "Apt 3B",
                isRequired: false,
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
                hint: "you@example.com",
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
              const SizedBox(height: 100), // to avoid bottom button overlap
            ],
          ),
        ),
      ),

      // Fixed bottom CTA
      bottomNavigationBar: SafeArea(
        child: Obx(() {
          final busy = chekoutController.isLoading.value;
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              height: isTablet ? 56 : 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: busy ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedPaymentMethod == 0
                                ? "Place Order (QR/UTR) • ₹${getTotalAmount()}"
                                : "Pay with Razorpay • ₹${getTotalAmount()}",
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

  // ---------- UI Builders ----------

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

          // Items
          ...widget.cartItems.map((item) {
            final lineAmount = (item.totalPrice ?? 0) * (item.quantity ?? 0);
            return Padding(
              padding: EdgeInsets.only(bottom: isTablet ? 8 : 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(item.courseName ?? 'Course',
                        style: GoogleFonts.lato(
                            fontSize: isTablet ? 16 : 14,
                            color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text("₹$lineAmount",
                      style: GoogleFonts.lato(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
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
                  //icon: Image.asset("assets/images/scannerimage.jpg") as IconData,
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
    // String ? iconImage,
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
            //Image.asset(iconImage.toString(), height: 40, width: 40),
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
                  border: Border.all(color: AppColors.primary)),
              child: Image.asset("assets/images/scannerimage.jpg", fit: BoxFit.contain),
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
          Text("Payment Screenshot",
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: isTablet ? 16 : 14)),
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
                        Text("Tap to upload payment screenshot",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(File(selectedImage!.path),
                          width: double.infinity, fit: BoxFit.cover),
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
                  fontSize: isTablet ? 15 : 14, color: Colors.blue[800]),
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
        Text('Other Payment Methods',
            style: GoogleFonts.lato(
                fontSize: isTablet ? 16 : 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => showPaymentDialog(context, isTablet),
          icon: Icon(Icons.qr_code, color: AppColors.primary),
          label: Text("Pay via UPI QR Code",
              style: GoogleFonts.lato(
                fontSize: isTablet ? 16 : 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              )),
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
        return StatefulBuilder(builder: (context, setSt) {
          return CupertinoAlertDialog(
            title: Text("Complete Payment",
                style: GoogleFonts.lato(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
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
                      Text("UPI ID: $upiId",
                          style: GoogleFonts.lato(
                            fontSize: isTablet ? 18 : 16,
                            color: AppColors.textPrimary,
                          )),
                      SizedBox(width: isTablet ? 12 : 8),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(Icons.copy,
                            size: isTablet ? 24 : 20, color: AppColors.primary),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: upiId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("UPI ID copied",
                                  style: GoogleFonts.lato(color: Colors.white)),
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
                        color: Colors.grey[400], fontSize: isTablet ? 16 : 14),
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
                        vertical: isTablet ? 12 : 10),
                    child: Text(
                      selectedImage == null
                          ? "Upload Payment Screenshot"
                          : "Change Payment Screenshot",
                      style: GoogleFonts.lato(
                          fontSize: isTablet ? 16 : 15, color: Colors.white),
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
                        child: Image.file(File(selectedImage!.path),
                            height: isTablet ? 120 : 100, fit: BoxFit.cover),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel",
                    style: GoogleFonts.lato(
                        fontSize: isTablet ? 16 : 14,
                        color: CupertinoColors.destructiveRed)),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  if (utrController.text.isEmpty || selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Please enter UTR and upload payment screenshot",
                            style: GoogleFonts.lato(color: Colors.white)),
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
                        content: Text("UTR must be 10-16 digits",
                            style: GoogleFonts.lato(color: Colors.white)),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  // Optional: trigger the same QR flow directly from dialog if you want
                  await _submit();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Place Order",
                        style: GoogleFonts.lato(
                            fontSize: 14, color: AppColors.primary)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward,
                        color: AppColors.primary, size: 16),
                  ],
                ),
              ),
            ],
          );
        });
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
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Enter a valid email address';
          }
          if (keyboardType == TextInputType.phone &&
              value != null &&
              value.length < 10) {
            return 'Enter a valid phone number';
          }
          return null;
        },
        style: GoogleFonts.lato(
            fontSize: isTablet ? 16 : 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.lato(
              color: Colors.grey[600], fontSize: isTablet ? 16 : 14),
          hintText: hint,
          hintStyle: GoogleFonts.lato(
              color: Colors.grey[400], fontSize: isTablet ? 16 : 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
              vertical: isTablet ? 16 : 12, horizontal: isTablet ? 20 : 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        ),
      ),
    );
  }
}
