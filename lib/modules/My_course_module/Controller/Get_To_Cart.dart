import 'package:get/get.dart';
import '../../../ApiServices/ApiServices.dart';
import '../../../utils/logx.dart';
import '../Model/My_Course_Model.dart';

class GetCartItem extends GetxController {
  final RxList<CartItem> coursecartList = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ApiService _api =
      ApiService(baseUrl: 'https://api.auratechacademy.com');

  Future<void> fetchCartItems(int userId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final Data = await _api.getList<CartItem>(
        "/add_to_cart/?user_id=$userId",
        (json) {
          return CartItem.fromJson(json);
        },
      );

      coursecartList.value = Data;
      LogX.printLog("Cart items fetched: ${Data.length}");
    } catch (e) {
      errorMessage.value = "Failed to fetch cart items: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  void updateLocalCartQuantity(int cartId, int newQuantity) {
    final index = coursecartList.indexWhere((item) => item.id == cartId);
    if (index != -1) {
      coursecartList[index].quantity = newQuantity;
      coursecartList.refresh();
    }
  }

  void removeLocalCartItem(int cartId) {
    coursecartList.removeWhere((item) => item.id == cartId);
    coursecartList.refresh();
  }
}
