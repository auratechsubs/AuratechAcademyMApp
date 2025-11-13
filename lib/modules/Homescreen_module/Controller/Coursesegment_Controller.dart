import 'dart:convert';
import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../utils/logx.dart';
import 'package:auratech_academy/modules/Homescreen_module/Model/Coursesegment_Model.dart'
as csmodel;
class CourseSegmentController extends GetxController {
  final ApiService _api =
      ApiService(baseUrl: 'https://api.auratechacademy.com/');
  // Endpoint & full URL
  static const String _endpoint = 'course_segment/';
  static const String _fullUrl =
      'https://api.auratechacademy.com/course_segment/';

  // States
  final RxList<csmodel.CourseSegment> segments = <csmodel.CourseSegment>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;


  @override
  void onInit() {
    super.onInit();
    fetchSegments();
  }

  Future<void> fetchSegments({bool forceRefresh = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      LogX.printLog('🚀 Fetching course segments from $_endpoint');

      final list = await _api.getList<csmodel.CourseSegment>(
        _endpoint,
        (json) => csmodel.CourseSegment.fromJson(json),
      );

      // basic validation + filter
      final filtered = list.where((item) {
        final idOk = (item.id ?? 0) > 0;
        final nameOk = (item.name ?? '').trim().isNotEmpty;
        final status = (item.recordStatus ?? '').toLowerCase();
        final activeOk = status.isEmpty || status == 'active';

        return idOk && nameOk && activeOk;
      }).toList();

      segments.assignAll(filtered);

      if (segments.isEmpty) {
        errorMessage.value = 'No active course segments found.';
        LogX.printLog('📭 No active segments found in response.');
      } else {
        LogX.printLog('✅ Loaded ${segments.length} course segments.');
      }
    } catch (e, s) {
      LogX.printError('❌ Error in getList() for course_segment: $e\n$s');

      // yahan hum direct raw API hit karke backend ka real error nikalne ki try karenge
      await _handleBackendErrorFallback(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleBackendErrorFallback(Object originalError) async {
    try {
      final res = await http.get(Uri.parse(_fullUrl));

      // agar yahan bhi success aa gaya to shayad pehle koi parsing error tha
      if (res.statusCode == 200) {
        errorMessage.value =
            'Something went wrong while parsing server data. Please try again.';
        LogX.printError(
            '⚠️ HTTP 200 but parsing failed earlier. Body: ${res.body}');
        return;
      }

      String backendMsg = 'Unknown server error';

      try {
        final Map<String, dynamic> body = jsonDecode(res.body);
        backendMsg = (body['message'] ??
                body['detail'] ??
                body['error'] ??
                body['errors'])
            .toString();
      } catch (_) {
        // agar JSON nahi hai to raw text dikha do
        backendMsg = res.body;
      }

      errorMessage.value =
          'Error ${res.statusCode}: $backendMsg'; // UI me ye dikha sakte ho
      LogX.printError(
          '🔥 Backend error ${res.statusCode}: $backendMsg (fallback call)');
    } catch (e2, s2) {
      // fallback bhi fail ho gaya -> original error hi dikha do
      errorMessage.value = originalError.toString();
      LogX.printError(
          '💀 Failed to fetch backend error as well: $e2\n$s2\nUsing original error: $originalError');
    }
  }
}
