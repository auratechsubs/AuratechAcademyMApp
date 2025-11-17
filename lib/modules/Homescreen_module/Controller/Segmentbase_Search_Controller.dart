import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:get/get.dart';
import '../../../utils/logx.dart';
import '../../Course_module/Model/Course_Master_Model.dart';


class CourseSegmantMasterController extends GetxController {
 final ApiService _api = ApiService(baseUrl: 'https://api.auratechacademy.com/');

  // ───────── STATE ─────────
  final RxList<CourseMaster> courses = <CourseMaster>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString currentSegment = ''.obs;

  // Optional: last search query (agar controller se bhi filter chahiye)
  final RxString searchQuery = ''.obs;

  // ───────── PUBLIC: Segment wise fetch ─────────
  Future<void> fetchCoursesBySegment(String segmentName) async {
    if (segmentName.isEmpty) {
      LogX.printError("⚠️ fetchCoursesBySegment called with empty segment");
      return;
    }

    currentSegment.value = segmentName;
    errorMessage.value = '';
    isLoading.value = true;

    // Important: kyunki "Data & AI Technologies" me '&' hai → encode zaroori
    final encodedSegment = Uri.encodeQueryComponent(segmentName);

    final endpoint = "coursemaster/?coursesegment_name=$encodedSegment";

    LogX.printLog("📡 Fetching courses for segment: '$segmentName'");
    LogX.printLog("🔗 Endpoint: $endpoint");

    try {
      final result = await _api.getList<CourseMaster>(
        endpoint,
            (json) => CourseMaster.fromJson(json),
      );

      courses.assignAll(result);
      LogX.printLog(
        "✅ Loaded ${courses.length} courses for segment: '$segmentName'",
      );

      if (courses.isEmpty) {
        LogX.printLog("ℹ️ No courses found for this segment.");
      }
    } catch (e, st) {
      errorMessage.value = e.toString();
      LogX.printError(
        "💥 Error while fetching courses for '$segmentName': $e\n$st",
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ───────── Optional: search filter helper ─────────

  List<CourseMaster> get filteredCourses {
    final q = searchQuery.value.trim().toLowerCase();

    if (q.isEmpty) return courses;

    return courses.where((c) {
      final title = c.courseTitle.toLowerCase();
      final segment = (c.courseCategory?.courseSegment?.name ?? '')
          .toLowerCase();
      final cat = (c.courseCategory?.categoryName ?? '').toLowerCase();
      return title.contains(q) || segment.contains(q) || cat.contains(q);
    }).toList();
  }
}
