import 'package:get/get.dart';
import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:auratech_academy/utils/logx.dart';

import 'Get_To_Cart.dart';

class DeleteCartItemController extends GetxController {
  final ApiService _apiService =
      ApiService(baseUrl: "https://api.auratechacademy.com");

  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  final GetCartItem getCartItemController = Get.find();

  Future<void> deleteCartItem(int cartId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.delete("/add_to_cart/$cartId/");
      LogX.printLog("✅ Deleted: $response");

      getCartItemController.removeLocalCartItem(cartId);

    } catch (e) {
      errorMessage.value = "Failed to delete item: $e";
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError);
      LogX.printError("❌ $errorMessage");
    } finally {
      isLoading.value = false;
    }
  }
}
