import 'package:auratech_academy/utils/logx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auratech_academy/ApiServices/ApiServices.dart';
import '../../../utils/storageservice.dart';
import '../../../widget/custombottombar.dart';
import '../../Setting_Module/Controller/Order_History_Controller.dart';
import '../Model/Login_Model.dart';

class LoginController extends GetxController {
  final ApiService _apiService =
      ApiService(baseUrl: "https://api.auratechacademy.com");

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final OrderHistoryController orderHistoryController = Get.find();
  var isLoading = false.obs;

  Future<void> loginUser(
    String email,
    String password,
    bool issso,
  ) async {
    print("Detail is $email $password");

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Validation Error", "Email and Password cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Weak Password", "Password must be at least 6 characters",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post<LoginResponse>(
        "/login/",
        {
          "user_input": email,
          "password": password,
          "is_sso": issso,
        },
        (json) => LoginResponse.fromJson(json),
      );

      // Save tokens
      StorageService.saveData('Access_Token', response.accessToken);
      StorageService.saveData('Refresh_Token', response.refreshToken);
      StorageService.saveData('Token_Time', response.tokenGeneratedTime);
      StorageService.saveData('User_id', response.userId);
      StorageService.saveData('Login Email', email);

      print("User Logged In => ${response.accessToken}");

      // Get.offAll(() => CongratulationsScreen(
      //       imagePath: 'assets/images/congratulationpic.png',
      //       title: 'Congratulations',
      //       subtitle: 'Your account is ready to use.\nRedirecting to home...',
      //       delaySeconds: 3,
      //     ));
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.green,
        title: "Login",
        message: "You are login successfully",
        isDismissible: true,
        duration: Duration(seconds: 1),
      ));
      Get.offAll(() => BottomnavBar());
    } catch (e) {
      final error = e.toString();
      String msg = error.contains('-') ? error.split('-').last.trim() : error;

      LogX.printError("Login Failed $msg");
      Get.snackbar("Login Failed", msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
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
