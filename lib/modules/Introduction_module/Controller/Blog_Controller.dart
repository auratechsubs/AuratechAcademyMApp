import 'package:get/get.dart';
import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:auratech_academy/utils/logx.dart';
import '../Model/Blog_Model.dart';

class BlogController extends GetxController {
  final RxList<Blog> blogList = <Blog>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ApiService _apiService =
      ApiService(baseUrl: "https://api.auratechacademy.com");


  Future<void> fetchBlogs() async {
    isLoading.value = true;
    errorMessage.value = "";

    try {
      final blogs = await _apiService.getList(
        "/blogpost/",
        (json) => Blog.fromJson(json),
      );

      blogList.assignAll(blogs);
      LogX.printLog("✅ Blog list fetched: ${blogs.length} items");
    } catch (e, stacktrace) {
      LogX.printError("❌ Failed to fetch blogs Error:  $e $stacktrace");
      errorMessage.value = "Failed to load blog posts.";
      LogX.printError("❌ Failed to fetch blogs Error:  $errorMessage");
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onInit() {
    fetchBlogs();
    super.onInit();
  }
}
