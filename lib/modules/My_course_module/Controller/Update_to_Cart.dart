
import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:auratech_academy/constant/constant_colors.dart';
import 'package:auratech_academy/utils/logx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/My_Course_Model.dart';
import 'Get_To_Cart.dart';

class IncreamentAndDecreamentController extends GetxController {
  final ApiService _apiService = ApiService(baseUrl: "https://api.auratechacademy.com");
  final GetCartItem getCartItemController = Get.find();

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxSet<int> loadingItems = <int>{}.obs;

  Future<void> updateCartQuantity(int cartId, int newQuantity) async {
    isLoading.value = true;
    errorMessage.value = '';
    loadingItems.add(cartId);
    try {

      final response = await _apiService.put(
        '/add_to_cart/$cartId/',
        {
          "quantity": newQuantity,
        },
        (json) => CartItem.fromJson(json),
      );
      LogX.printLog(response.toString());

      getCartItemController.updateLocalCartQuantity(cartId, newQuantity);

      LogX.printLog("✅ Quantity updated to $newQuantity");
    } catch (e) {
      errorMessage.value = "Failed to update quantity: ${e.toString()}";
      Get.snackbar(
        "Error",
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      LogX.printError("❌ $errorMessage");
    } finally {
      isLoading.value = false;
      loadingItems.remove(cartId);
    }
  }


  Future<void> incrementQuantity(int cartId, int currentQuantity) async {
    int newQuantity = currentQuantity + 1;
    await updateCartQuantity(cartId, newQuantity);
  }


  Future<void> decrementQuantity(int cartId, int currentQuantity) async {
    if (currentQuantity > 1) {
      int newQuantity = currentQuantity - 1;
      await updateCartQuantity(cartId, newQuantity);
    } else {
      Get.snackbar(
        "Notice",
        "Minimum quantity is 1",
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
