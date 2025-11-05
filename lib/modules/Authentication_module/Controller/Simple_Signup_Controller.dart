import 'package:auratech_academy/constant/constant_colors.dart';
import 'package:auratech_academy/modules/Authentication_module/View/LoginScreen.dart';
import 'package:auratech_academy/utils/util_klass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auratech_academy/ApiServices/ApiServices.dart';

class SignupResponse {
  final String message;

  SignupResponse({required this.message});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      message: json['message'] ?? 'Success',
    );
  }
}

class SimpleLoginController extends GetxController {
  final ApiService _apiService =
      ApiService(baseUrl: "https://api.auratechacademy.com");

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> signUpUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    print(email);
    print(password);
    // Validation
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Validation Error", "Email and Password cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Weak Password", "Password must be at least 6 characters");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post<SignupResponse>(
        "/usersignup/",
        {
          "user_input": email,
          "password": password,
        },
        (json) => SignupResponse.fromJson(json),
      );
      Get.snackbar(
        "Success",
        response.message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 50, left: 16, right: 16),
        backgroundColor:  AppColors.primary,
        colorText: Colors.white,
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        shouldIconPulse: true,
        duration: const Duration(seconds: 3),
      );
      print(response.message);
      UtilKlass.navigateScreenOffAll(LoginScreen());
    } catch (e) {
      final error = e.toString();
      final message = error.contains('-')
          ? error.split('-').last.trim() // "-" ke baad ka part le lega
          : error;
      Get.snackbar(
        "Signup Failed",
        message,
        snackPosition: SnackPosition.BOTTOM, // bottom me show karega
        margin: const EdgeInsets.only(bottom: 50, left: 16, right: 16), // thoda upar lift karega
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        shouldIconPulse: true,
        duration: const Duration(seconds: 3),
      );
      print("Signup Failed $message");
    }
    finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
