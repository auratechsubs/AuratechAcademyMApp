import 'package:get/get.dart';

class Homescreen_Controller extends GetxController {
  RxInt selectedTabIndex = 0.obs;

  void selectTab(int idx) {
    print("Tab changed to: $idx");
    selectedTabIndex.value = idx;
  }
}
