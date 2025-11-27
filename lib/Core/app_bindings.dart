import 'package:get/get.dart';

import '../modules/Authentication_module/Controller/Login_Controller.dart';
import '../modules/Authentication_module/Controller/Google_Signup_Controller.dart';
import '../modules/Authentication_module/Controller/Simple_Signup_Controller.dart';

import '../modules/Course_module/Controller/Learning_Module_Controller.dart';
import '../modules/Homescreen_module/Controller/Coursesegment_Controller.dart';
import '../modules/Homescreen_module/Controller/Flash_deal_controller.dart';
import '../modules/Homescreen_module/Controller/HomeScreen_Controller.dart';
import '../modules/Homescreen_module/Controller/Segmentbase_Search_Controller.dart';
import '../modules/Homescreen_module/Controller/SuccessStoryController.dart';
import '../modules/Homescreen_module/Controller/Testimonial_controller.dart';
import '../modules/Homescreen_module/Controller/GalleyMaterController.dart';
import '../modules/Homescreen_module/Controller/Webminar_Controller.dart';
import '../modules/Introduction_module/Controller/Blog_Controller.dart';

import '../modules/Category_module/Controller/Category_controller.dart';
import '../modules/Course_module/Controller/Popular_course_controller.dart';
import '../modules/Course_module/Controller/Course_review_Controller.dart';
import '../modules/Course_module/Controller/getReviewController.dart';

import '../modules/My_course_module/Controller/Add_To_Cart.dart';
import '../modules/My_course_module/Controller/Get_To_Cart.dart';
import '../modules/My_course_module/Controller/Update_to_Cart.dart';
import '../modules/My_course_module/Controller/delete_cart_item.dart';
import '../modules/Payment_module/Controller/Chekout_Cotroller.dart';
import '../modules/Setting_Module/Controller/Order_History_Controller.dart';
import '../modules/Setting_Module/Controller/FaqController.dart';

import '../modules/Mentor_module/Controller/Mentor_Controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Auth
    // Get.lazyPut<LocalizationController>(() => LocalizationController(), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<GoogleSigninController>(() => GoogleSigninController(),
        fenix: true);
    Get.lazyPut<SimpleLoginController>(() => SimpleLoginController(),
        fenix: true);


    // Home/Intro
    Get.lazyPut<Homescreen_Controller>(() => Homescreen_Controller(),
        fenix: true);
    Get.lazyPut<TestimonialController>(() => TestimonialController(),
        fenix: true);
    Get.lazyPut<GalleryMasterController>(() => GalleryMasterController(),
        fenix: true);
    Get.lazyPut<BlogController>(() => BlogController(), fenix: true);
    Get.lazyPut<CourseSegmentController>(() => CourseSegmentController(), fenix: true);
    Get.lazyPut<FlashBannerController>(() => FlashBannerController(), fenix: true);
    Get.lazyPut<SuccessStoryController>(() => SuccessStoryController(), fenix: true);
    Get.lazyPut<WebinarController>(() => WebinarController(), fenix: true);
    Get.lazyPut<CourseSegmantMasterController>(() => CourseSegmantMasterController(), fenix: true);
    Get.lazyPut<Learning_Module_Controller>(() => Learning_Module_Controller(), fenix: true);

    // Category & Courses
    Get.lazyPut<Category_Controller>(() => Category_Controller(), fenix: true);
    Get.lazyPut<PopularCourseController>(() => PopularCourseController(),
        fenix: true);
    Get.lazyPut<PostReviewController>(() => PostReviewController(),
        fenix: true);
    Get.lazyPut<getReviewController>(() => getReviewController(), fenix: true);

    // Cart/Orders/Payment
    Get.lazyPut<AddToCart>(() => AddToCart(), fenix: true);
    Get.lazyPut<GetCartItem>(() => GetCartItem(), fenix: true);
    Get.lazyPut<IncreamentAndDecreamentController>(
        () => IncreamentAndDecreamentController(),
        fenix: true);
    Get.lazyPut<DeleteCartItemController>(() => DeleteCartItemController(),
        fenix: true);
    Get.lazyPut<ChekoutController>(() => ChekoutController(), fenix: true);
    Get.lazyPut<OrderHistoryController>(() => OrderHistoryController(),
        fenix: true);

    // Mentor
    Get.lazyPut<Mentor_Controller>(() => Mentor_Controller(), fenix: true);

    // Settings/FAQ
    Get.lazyPut<FaqController>(() => FaqController(), fenix: true);
   // Get.lazyPut(LocalizationController(), permanent: true);

  }
}
