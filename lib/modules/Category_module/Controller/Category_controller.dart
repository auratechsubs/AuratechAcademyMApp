import 'dart:convert';
import 'package:auratech_academy/utils/logx.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Model/Course_Category_Model.dart';

class Category_Controller extends GetxController {
  RxList<CourseCategoryModel> categoryList = <CourseCategoryModel>[].obs;
  RxList<CourseCategoryModel> filterCategories = <CourseCategoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  final String _endpoint = 'https://api.auratechacademy.com/coursecategory/';
  @override
  void onInit() {
    fetchCourseCategories();
    super.onInit();
  }

  void filterCategory(String query) {
    if (query.trim().isEmpty) {
      filterCategories.value = categoryList;
    } else {
      filterCategories.value = categoryList
          .where((item) =>
              item.categoryName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> fetchCourseCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse(_endpoint),
        headers: {
          'Accept': 'application/json',
        },
      );

      LogX.printLog(' Status Code: ${response.statusCode}');
      LogX.printLog(' Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);

        if (decodedBody is Map<String, dynamic> &&
            decodedBody.containsKey('data') &&
            decodedBody['data'] is List) {
          final courseCategoryResponse =
              CourseCategoryResponse.fromJson(decodedBody);
          categoryList.value = courseCategoryResponse.data;
          filterCategories.value = courseCategoryResponse.data;
        } else {
          errorMessage.value = 'Invalid API structure.';
          LogX.printWarning(' Unexpected response structure');
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
        LogX.printWarning(' Server returned ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Failed to load categories: $e';
      LogX.printWarning(' Exception: $e');
      LogX.printWarning(' StackTrace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }
}
