import 'package:auratech_academy/utils/logx.dart';
import 'package:get/get.dart';
import '../../../ApiServices/ApiServices.dart';
import '../Model/Course_Master_Model.dart';

class PopularCourseController extends GetxController {
  RxList<CourseMaster> courseList = <CourseMaster>[].obs;

  RxList<CourseMaster> filterCourse = <CourseMaster>[].obs;
  RxList<CourseMaster> HomeFileterCourse = <CourseMaster>[].obs;

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourseMasters();
  }

  void filterCategory(String query) {
    if (query.trim().isEmpty) {
      filterCourse.value = courseList;
    } else {
      filterCourse.value = courseList
          .where((item) =>
              item.courseTitle.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }


  RxString selectedCategory = ''.obs;

  void HomefilterCorse(String query) {
    selectedCategory.value = query;
    if (query.trim().isEmpty || query == "All") {
      HomeFileterCourse.value = courseList;
    } else {
      HomeFileterCourse.value = courseList
          .where((item) =>
      item.courseCategory?.categoryName.toLowerCase() ==
          query.toLowerCase())
          .toList();
    }
  }

  final ApiService _api = ApiService(baseUrl: 'https://api.auratechacademy.com');
  Future<void> fetchCourseMasters() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      List<CourseMaster> courses = await _api.getList(
        '/coursemaster/',
        (json) => CourseMaster.fromJson(json),
      );

      courseList.value = courses;
      filterCourse.value = courses;
      HomeFileterCourse.value = courses;
      LogX.printLog("Courses fetched: ${courses.length}");
      LogX.printLog("First Course: ${courses.isEmpty}");
    } catch (e) {
      errorMessage.value = 'Error fetching courses: $e';
      LogX.printError('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
