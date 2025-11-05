import 'package:get/get.dart';
import '../../../ApiServices/ApiServices.dart';
import '../../../utils/logx.dart';
import '../Model/FaqModel.dart';

class FaqController extends GetxController {
  final RxList<FaqItem> faqList = <FaqItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ApiService _api = ApiService(baseUrl: 'https://api.auratechacademy.com');

  Future<void> fetchFaqs() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final List<FaqItem> data = await _api.getList<FaqItem>(
        "/coursefaq/",
            (json) => FaqItem.fromJson(json),
      );

      faqList.value = data ;
      print(data);
      LogX.printLog("📘 Faq items fetched: ${data.length}");
    } catch (e) {
      errorMessage.value = "Failed to fetch FAQs: ${e.toString()}";
      LogX.printError("❌ FAQ Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }
}
