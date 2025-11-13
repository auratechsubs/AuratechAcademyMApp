// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sms_autofill/sms_autofill.dart';
//
// class MobileLoginController extends GetxController with CodeAutoFill {
//   final mobileController = TextEditingController();
//   final otpController = TextEditingController();
//
//   final isOtpSent = false.obs;
//   final isLoading = false.obs;
//   final resendAfter = 30.obs;
//
//   Timer? _timer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     listenForCode();
//   }
//
//   @override
//   void codeUpdated() {
//     otpController.text = code!;
//     verifyOtp(code!);
//   }
//
//   void sendOtp() async {
//     if (mobileController.text.length < 10) {
//       Get.snackbar("Error", "Please enter a valid mobile number",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     isLoading.value = true;
//     await Future.delayed(const Duration(seconds: 1));
//     isLoading.value = false;
//     isOtpSent.value = true;
//     startResendTimer();
//   }
//
//   void startResendTimer() {
//     resendAfter.value = 30;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (resendAfter.value > 0) {
//         resendAfter.value--;
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   void verifyOtp(String otp) {
//     if (otp == "123456") {
//       Get.snackbar("Success", "OTP Verified Successfully",
//           snackPosition: SnackPosition.BOTTOM);
//     } else {
//       Get.snackbar("Error", "Invalid OTP", snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     cancel();
//     mobileController.dispose();
//     otpController.dispose();
//     super.onClose();
//   }
// }
