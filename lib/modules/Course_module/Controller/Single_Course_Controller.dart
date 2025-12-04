import 'package:get/get.dart';
import 'package:auratech_academy/utils/logx.dart';

import '../../../ApiServices/ApiServices.dart';
import '../Model/SingleCourseModel.dart';
import '../Model/Course_Master_Model.dart';

class SingleCourseController extends GetxController {
   final ApiService _api = ApiService(
    baseUrl: 'https://api.auratechacademy.com/',
  );

  // ▶️ UI state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ▶️ Single course data (nullable)
  final Rxn<CourseMaster> singleCourse = Rxn<CourseMaster>();

  Future<void> fetchCourseBySlug(String slug) async {
    isLoading.value = true;
    errorMessage.value = '';
    singleCourse.value = null;

    final String endpoint = 'coursemaster/$slug/';

    try {
      final SingleCourseModel result = await _api.getObject<SingleCourseModel>(
        endpoint,
        (json) => SingleCourseModel.fromJson(json),
      );

      singleCourse.value = result.data;

      LogX.printLog('✅ Course loaded for slug: $slug');
      LogX.printLog('🎓 Title: ${singleCourse.value?.courseTitle}');
    } catch (e, stackTrace) {
      errorMessage.value = 'Failed to load course: $e';
      LogX.printError('❌ Error fetching course for slug: $slug');
      LogX.printError(' Exception: $e');
      LogX.printError(' StackTrace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }
}
