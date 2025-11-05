import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ApiServices/ApiServices.dart';
import '../../../utils/logx.dart';
import '../Model/Course_Review_Get_Response_Model.dart';

class getReviewController  extends GetxController{
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<CourseReview> courseReviews = <CourseReview>[].obs;

  final ApiService _apiService =
  ApiService(baseUrl: "https://api.auratechacademy.com");

  Future<void> getReview() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await _apiService.getList<CourseReview>(
        "/coursereview/",
            (json) {
          LogX.printLog("🔍 Review JSON: $json");
          return CourseReview.fromJson(json);
        },
      );
      print("🔍 Raw Response: ${response.toList()}");



      courseReviews.assignAll(response);
      LogX.printLog("Fetched ${courseReviews.length} reviews");
        } catch (e) {
      errorMessage.value = "Failed to load reviews: $e";
      LogX.printLog("Error: ${errorMessage.value}");
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onInit() {
    // getReview();
    super.onInit();
  }
}