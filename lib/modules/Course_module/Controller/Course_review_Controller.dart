import 'package:auratech_academy/utils/logx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auratech_academy/ApiServices/ApiServices.dart';
import '../Model/Course_Review_Response_Model.dart';

class PostReviewController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<CourseReview?> postedReview = Rx<CourseReview?>(null);

  final ApiService _apiService =
      ApiService(baseUrl: "https://api.auratechacademy.com");

  // POST Review
  Future<void> postReview({
    required int courseId,
    required int userId,
    required String reviewName,
    required String reviewEmail,
    required String reviewMessage,
    required int status,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await _apiService.post(
        "/coursereview/",
        {
          "CourseReview_Course_id": courseId,
          "CourseRevie_user_id": userId,
          "CourseReview_name": reviewName,
          "CourseReview_email": reviewEmail,
          "CourseReview_remark": reviewMessage,
          "status": status,
        },
        (json) => CourseReview.fromJson(json),
      );

      postedReview.value = response;
      LogX.printLog(response.toString());
      Get.snackbar("Success", "Review posted successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      errorMessage.value = "Failed to post review: $e";
      LogX.printLog("Error  ${errorMessage.value}");
      Get.snackbar("Error", errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Get.theme.colorScheme.onError);
    } finally {
      isLoading.value = false;
    }
  }

}
