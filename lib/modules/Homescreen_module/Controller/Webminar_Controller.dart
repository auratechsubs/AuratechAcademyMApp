import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:get/get.dart';
import 'package:auratech_academy/utils/logx.dart';

import '../Model/Webminar_Model.dart';

class WebinarController extends GetxController {
  final ApiService _api =
      ApiService(baseUrl: 'https://api.auratechacademy.com/');
  var webinars = <WebinarModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;

  final String endpoint = "webinar/";

  @override
  void onInit() {
    super.onInit();
    fetchWebinars();
  }

  // 🔥 Fetch all webinar banners
  Future<void> fetchWebinars() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      LogX.printLog("🚀 Fetching Webinars from API: $endpoint");

      final List<WebinarModel> response =
          await _api.getList<WebinarModel>(endpoint, (json) {
        LogX.printLog("📝 Parsing Webinar Item: ${json['title']}");
        return WebinarModel.fromJson(json);
      });

      webinars.assignAll(response);

      LogX.printLog("✅ Webinars Loaded: ${webinars.length} records fetched.");
    } catch (e) {
      LogX.printError("❌ Webinar Fetch Error: $e");

      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      LogX.printLog("⏳ Fetch Request Finished.");
    }
  }
}
