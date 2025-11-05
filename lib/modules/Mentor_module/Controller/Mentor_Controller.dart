import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:get/get.dart';

import '../../../utils/logx.dart';
import '../../Course_module/Model/Course_Master_Model.dart';

class Mentor_Controller extends GetxController {
  RxList<CourseInstructor> mentorList = <CourseInstructor>[].obs;

  // Filtered list for UI use
  RxList<CourseInstructor> mentorFilterList = <CourseInstructor>[].obs;

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  final String _endpoint = 'https://api.auratechacademy.com/courseinstructor/';

  @override
  void onInit() {
    super.onInit();
    getMentors();
    // fetchCourseMaster(); // ✅ Start loading
  }

  final ApiService _api =
      ApiService(baseUrl: "https://api.auratechacademy.com/");
  Future<void> getMentors() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      List<CourseInstructor> mentors = await _api.getList(
        '/courseinstructor/',
        (json) => CourseInstructor.fromJson(json),
      );

      mentorList.value = mentors;
      mentorFilterList.value = mentors;
      LogX.printLog("Courses fetched: ${mentors.length}");
      LogX.printLog("First Course: ${mentors.isEmpty}");
    } catch (e) {
      errorMessage.value = 'Error fetching mentors: $e';
      LogX.printError('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
