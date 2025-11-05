import 'package:auratech_academy/utils/logx.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../ApiServices/ApiServices.dart';

import '../Model/Cart_Model.dart';

class AddToCart extends GetxController {
  final ApiService _apiService =
      ApiService(baseUrl: "https://api.auratechacademy.com");

  var isLoading = false.obs;
  CartModel? cartModel;

  Future<void> addToCart({
    required int user_id,
    required int course_id,
    required int quantity,
  }) async {
    try {
      isLoading.value = true;

      LogX.printLog("Adding to cart: user_id=$user_id, course_id=$course_id, quantity=$quantity");
      final response = await _apiService.post<CartModel>(
        "/add_to_cart/",
        {
          "user_id": user_id,
          "course_id": course_id,
          "quantity": quantity,
        },
        (json) => CartModel.fromJson(json),
      );

      cartModel = response;

      LogX.printLog(response.message ?? "No message");
      LogX.printLog("Success ${response.data?.toString()}");

      debugPrint(" Course: ${response.data?.courseName ?? '-'}");
      debugPrint(" Quantity: ${response.data?.quantity ?? '-'}");
      debugPrint(" Total Price: ₹${response.data?.totalPrice ?? '-'}");

    } catch (e) {
      Get.snackbar("Add to Cart Failed", e.toString());
      print(" Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
