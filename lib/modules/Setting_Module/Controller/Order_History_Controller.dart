import 'package:get/get.dart';
import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:auratech_academy/utils/logx.dart';
import '../../../utils/storageservice.dart';
import '../Model/Order_History_Model.dart';

class OrderHistoryController extends GetxController {
  final RxList<OrderData> orderHistoryList = <OrderData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ApiService _apiService =
      ApiService(baseUrl: "https://api.auratechacademy.com");

  Future<void> fetchOrderHistory({required int userId}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final data = await _apiService.getList<OrderData>(
        "/courseorder/?user_id=$userId",
        (json) => OrderData.fromJson(json),
      );

      orderHistoryList.value = data;
      LogX.printLog("✅ Order history fetched for id: $userId");
      LogX.printLog("✅ Order history fetched: ${data.length}");
    } catch (e) {
      LogX.printError("❌ FetchOrderHistory Error: $e");
      errorMessage.value = "Failed to fetch order history. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrderHistory() async {
    int? userId = StorageService.getData("User_id");
    if (userId != null) {
      await fetchOrderHistory(userId: userId);
    } else {
      errorMessage.value = "User not logged in.";
    }
  }
}
