import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class UtilKlass {
  static void navigateScreen(Widget widget) {
    Get.to(widget, transition: Transition.cupertino);
  }

  static void navigateScreenArguments(Widget widget, dynamic args) {
    Get.to(widget, transition: Transition.cupertino, arguments: args);
  }

  static void navigateScreenOff(Widget widget) {
    Get.off(widget, transition: Transition.cupertino);
  }

  static void navigateScreenOffAll(Widget widget) {
    Get.offAll(widget, transition: Transition.fade);
  }

  static bool checkIsAndroid() {
    var isAndroid = GetPlatform.isAndroid;
    return isAndroid;
  }

  static bool checkIsIOS() {
    var isIOS = GetPlatform.isIOS;
    return isIOS;
  }

  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }

  static void showToastMsg(String message, BuildContext context) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      backgroundColor: Colors.black87,
      textStyle: const TextStyle(color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }
  static void showToastMsgWithoutContext(String message) {
    showToast(
      message,
      backgroundColor: Colors.black87,
      textStyle: const TextStyle(color: Colors.white),
      animation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 2),
     );
  }
  static void showBarMsg(String dynamic) {
    Get.snackbar("", dynamic);


  }

  static String getString(TextEditingController controller) {
    if (controller.text.isEmpty) {
      return "";
    } else {
      return controller.text.toString().trim();
    }
  }

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Color randomColor() {
    return Color(Random().nextInt(0xffffffff));
  }

  static showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 90,
          width: 90,
          child: Text("Please wait"),
        );
      },
    );
  }

  static hideProgressDialog(BuildContext context) {

    Navigator.of(context, rootNavigator: true).pop();
  }
}