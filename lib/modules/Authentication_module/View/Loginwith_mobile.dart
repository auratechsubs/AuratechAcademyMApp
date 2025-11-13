// import 'package:auratech_academy/constant/constant_assets.dart';
// import 'package:auratech_academy/constant/constant_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
//
// import '../Controller/Loginwith_mobilenumber_Controller.dart';
//
//
// class MobileLoginScreen extends StatelessWidget {
//   const MobileLoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(MobileLoginController());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 40),
//               Image.asset(Assets.Splacescreenseconflogo, height: 150),
//               const SizedBox(height: 40),
//               const Text(
//                 "Auratech Academy",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 30),
//               TextField(
//                 controller: controller.mobileController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: "Enter Mobile Number",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   prefixIcon: const Icon(Icons.phone),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//
//               Obx(() => controller.isLoading.value
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: controller.isOtpSent.value &&
//                     controller.resendAfter.value > 0
//                     ? null
//                     : controller.sendOtp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: Text(
//                   controller.isOtpSent.value &&
//                       controller.resendAfter.value > 0
//                       ? "Resend in ${controller.resendAfter.value}s"
//                       : "Send OTP",
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               )),
//               const SizedBox(height: 20),
//               Obx(() => controller.isOtpSent.value
//                   ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Enter OTP", style: TextStyle(fontSize: 16)),
//                   const SizedBox(height: 10),
//                   Pinput(
//                     controller: controller.otpController,
//                     length: 6,
//                     onCompleted: controller.verifyOtp,
//                     defaultPinTheme: PinTheme(
//                       width: 50,
//                       height: 56,
//                       textStyle: const TextStyle(fontSize: 20),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.blueAccent),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//                   : const SizedBox()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
