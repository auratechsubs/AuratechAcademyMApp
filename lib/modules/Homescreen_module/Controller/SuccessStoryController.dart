import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:get/get.dart';
import 'package:auratech_academy/utils/logx.dart';

import '../Model/SuccessStoryModel.dart';

class SuccessStoryController extends GetxController {
  final ApiService _api = ApiService(baseUrl: 'https://api.auratechacademy.com/');
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<SuccessStoryModel> stories = <SuccessStoryModel>[].obs;

  static const String endpoint = "success_story/";

  Future<void> fetchSuccessStories() async {
    LogX.printLog("🚀 Fetching Success Stories...");

    try {
      isLoading.value = true;
      errorMessage.value = "";
      stories.clear();

      final List<SuccessStoryModel> result =
          await _api.getList<SuccessStoryModel>(
        endpoint,
        (json) => SuccessStoryModel.fromJson(json),
      );

      if (result.isEmpty) {
        LogX.printLog("⚠️ No success stories found.");
      } else {
        LogX.printLog("✅ ${result.length} Success Stories loaded!");
      }

      stories.assignAll(result);
    } catch (e) {
      LogX.printError("❌ API ERROR in SuccessStory: $e");
      errorMessage.value = "Failed to load success stories.\n$e";
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchSuccessStories();
  }
}
