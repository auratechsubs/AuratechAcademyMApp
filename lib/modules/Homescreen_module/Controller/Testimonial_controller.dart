import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Model/Tesrtimonial_Modal.dart';


class TestimonialController extends GetxController {

  RxList<Testimonial> testimonials = <Testimonial>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  final String _endpoint = 'https://api.auratechacademy.com/testimonial/';

  @override
  void onInit() {
    super.onInit();
    fetchTestimonials();
  }

  Future<void> fetchTestimonials() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(Uri.parse(_endpoint));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final testimonialResponse = TestimonialResponse.fromJson(jsonData);
        testimonials.value = testimonialResponse.data;
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load testimonials: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
