import 'package:get/get.dart';
import '../../../ApiServices/ApiServices.dart';
import '../../../utils/logx.dart';
import '../Model/GalleryMasterModel.dart';

class GalleryMasterController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<GalleryItem> imageList = <GalleryItem>[].obs;

  final ApiService _apiService =
  ApiService(baseUrl: "https://api.auratechacademy.com");

  Future<void> getGalleryItems() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final List<GalleryItem> items = await _apiService.getListFromObject<GalleryItem>(
        "/GalleryMaster/",
            (json) => GalleryItem.fromJson(json),
      );

      imageList.assignAll(items);
      LogX.printLog("Gallery Items Loaded: ${imageList.length}");
    } catch (e) {
      LogX.printError('Gallery fetch error: ${e.toString()}');
      errorMessage.value = 'Failed to load gallery items. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onInit() {
    getGalleryItems();
    super.onInit();
  }
}
