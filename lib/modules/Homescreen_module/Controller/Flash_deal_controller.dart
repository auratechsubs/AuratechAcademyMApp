import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:get/get.dart';
 import '../../../utils/logx.dart';
import '../Model/Flash_Deal_Model.dart';

class FlashBannerController extends GetxController {
 final ApiService _api = ApiService(baseUrl: 'https://api.auratechacademy.com/');
   static const String _endpoint = 'flash_deals/';

  // state
  final RxList<FlashBanner> banners = <FlashBanner>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFlashBanners();
  }

  Future<void> fetchFlashBanners({bool forceRefresh = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      LogX.printLog('🚀 Fetching flash banners from $_endpoint');

      final list = await _api.getList<FlashBanner>(
        _endpoint,
            (json) => FlashBanner.fromJson(json),
      );

      // Basic validation + filter (id, name, active, img)
      final filtered = list.where((b) {
        final idOk = (b.id ?? 0) > 0;
        final nameOk = (b.name ?? '').trim().isNotEmpty;
        final status = (b.recordStatus ?? '').toLowerCase();
        final isActive = status.isEmpty || status == 'active';
        final imgOk = (b.img ?? '').trim().isNotEmpty;

        return idOk && nameOk && isActive && imgOk;
      }).toList();

      banners.assignAll(filtered);

      if (banners.isEmpty) {
        errorMessage.value = 'No active flash banners available.';
        LogX.printLog('📭 No active flash banners found in response.');
      } else {
        LogX.printLog('✅ Loaded ${banners.length} flash banners.');
      }
    } catch (e, s) {
      LogX.printError('❌ Error fetching flash banners: $e\n$s');
      errorMessage.value = e.toString(); // yahi UI me dikha sakte ho
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFlashBanners() async {
    await fetchFlashBanners(forceRefresh: true);
  }
}
