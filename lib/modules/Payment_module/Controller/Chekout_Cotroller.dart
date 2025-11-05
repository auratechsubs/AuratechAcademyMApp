// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:auratech_academy/ApiServices/ApiServices.dart';
// // import 'package:auratech_academy/utils/logx.dart';
// // import 'package:get/get.dart';
// // import '../../../utils/storageservice.dart';
// // import '../Model/ChekoutModel.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:path/path.dart' as p;
// //
// // class ChekoutController extends GetxController {
// //   RxBool isLoading = false.obs;
// //   RxString errorMessage = "".obs;
// //   Rx<OrderResponseModel?> orderResponse = Rx<OrderResponseModel?>(null);
// //
// //   final ApiService _apiService = ApiService(baseUrl: "https://api.auratechacademy.com");
// //
// //   Future<void> checkout({
// //     required File? paymentScreenshot,
// //     required int userId,
// //     required String utr_no,
// //     required List cartitemIds,
// //     required String firstName,
// //     required String lastName,
// //     required String countryName,
// //     required String companyName,
// //     required String streetAddress,
// //     required String apartmentNo,
// //     required String cityName,
// //     required String postCode,
// //     required String emailAddress,
// //     required String phoneNumber,
// //   }) async {
// //     isLoading.value = true;
// //     errorMessage.value = "";
// //     orderResponse.value = null;
// //
// //     final uri = Uri.parse("https://api.auratechacademy.com/orderdetail/");
// //
// //     try {
// //       if (paymentScreenshot == null) {
// //         throw Exception("Payment screenshot is missing");
// //       }
// //
// //       final req = http.MultipartRequest('POST', uri);
// //
// //       // ── FIELDS (NOTE: currently CSV string; see notes below)
// //       final fields = <String, String>{
// //         "user_id": userId.toString(),
// //         "cartitem_ids": cartitemIds.join(','),
// //         "First_name": firstName,
// //         "Lirst_name": lastName,
// //         "Country_name": countryName,
// //         "your_company_name": companyName,
// //         "street_address": streetAddress,
// //         "Apartment_no": apartmentNo,
// //         "city": cityName,
// //         "postcode": postCode,
// //         "Email_address": emailAddress,
// //         "phone_no": phoneNumber,
// //         "utr_number": utr_no,
// //       };
// //       req.fields.addAll(fields);
// //
// //       // ── FILE
// //       final fileName = p.basename(paymentScreenshot.path);
// //       final file = await http.MultipartFile.fromPath(
// //         'payment_screenshot',
// //         paymentScreenshot.path,
// //       );
// //       req.files.add(file);
// //
// //       // ── DEBUG: request snapshot BEFORE send ─────────────────────────
// //       final filesMeta = req.files
// //           .map((f) => {
// //         "field": f.field,
// //         "filename": f.filename,
// //         "length": f.length,
// //       })
// //           .toList();
// //
// //       // Pretty print fields & files
// //       LogX.printLog("➡️  POST $uri");
// //       LogX.printLog("➡️  Fields: ${const JsonEncoder.withIndent('  ').convert(fields)}");
// //       LogX.printLog("➡️  Files:  ${const JsonEncoder.withIndent('  ').convert(filesMeta)}");
// //
// //       // cURL helper (approx; multipart boundary auto-generate hota hai)
// //       final curl = _toCurlPreview(
// //         url: uri.toString(),
// //         fields: fields,
// //         fileField: 'payment_screenshot',
// //         filePath: paymentScreenshot.path,
// //         fileName: fileName,
// //       );
// //       LogX.printLog("➡️  cURL preview:\n$curl");
// //       // ────────────────────────────────────────────────────────────────
// //
// //       // SEND
// //       final streamedResponse = await req.send();
// //       final response = await http.Response.fromStream(streamedResponse);
// //
// //       // ── DEBUG: full response dump
// //       final prettyHeaders = const JsonEncoder.withIndent('  ')
// //           .convert(response.headers.map((k, v) => MapEntry(k, v.toString())));
// //       LogX.printLog("⬅️  Response ${response.statusCode}");
// //       LogX.printLog("⬅️  Headers:\n$prettyHeaders");
// //       LogX.printLog("⬅️  Body:\n${response.body}");
// //
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final jsonResponse = jsonDecode(response.body);
// //         final parsed = OrderResponseModel.fromJson(jsonResponse);
// //         orderResponse.value = parsed;
// //
// //         LogX.printLog("✅ Order placed successfully");
// //         Get.snackbar("Order Success ", "✅ Order placed successfully");
// //         StorageService.saveData("refresh_profile", true);
// //       } else {
// //         errorMessage.value = "Server returned ${response.statusCode}: ${response.body}";
// //         LogX.printError(errorMessage.value);
// //         Get.snackbar("Error", errorMessage.value);
// //       }
// //     } catch (e, st) {
// //       errorMessage.value = "Checkout failed: ${e.toString()}";
// //       LogX.printError("Checkout failed: ${e.toString()}\n$st");
// //       Get.snackbar("Error", errorMessage.value);
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   /// Builds an approximate cURL preview for quick reproduction.
// //   String _toCurlPreview({
// //     required String url,
// //     required Map<String, String> fields,
// //     required String fileField,
// //     required String filePath,
// //     required String fileName,
// //   }) {
// //     final buf = StringBuffer();
// //     buf.writeln("curl -X POST '$url' \\");
// //     fields.forEach((k, v) {
// //       // Escape single quotes in values for shell safety
// //       final safe = v.replaceAll("'", r"'\''");
// //       buf.writeln("  -F '$k=$safe' \\");
// //     });
// //     buf.writeln("  -F '$fileField=@$filePath;filename=$fileName'");
// //     return buf.toString();
// //   }
// // }
//
// import 'package:auratech_academy/ApiServices/ApiServices.dart';
// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import '../../../ApiServices/razorpay_service.dart';
// import '../../../widget/custombottombar.dart';
// import '../Model/ChekoutModel.dart';
// import 'package:flutter/material.dart';
//
// class ChekoutController extends GetxController {
//
//   RxBool isLoading = false.obs;
//   RxString errorMessage = "".obs;
//   Rx<OrderResponseModel?> orderResponse = Rx<OrderResponseModel?>(null);
//
//   ///razorpay controller
//
//   final RazorpayService _razorpayService = RazorpayService();
//   final RxBool _isPaymentProcessing = false.obs;
//
//
//
//
//   @override
//   void onInit() {
//     _initializeRazorpay();
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     _razorpayService.dispose();
//     super.onClose();
//   }
//
//   void _initializeRazorpay() {
//     _razorpayService.initialize(
//       onSuccess: _handlePaymentSuccess,
//       onFailure: _handlePaymentFailure,
//       onExternalWallet: _handleExternalWallet,
//     );
//   }
//
//
//
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     _isPaymentProcessing.value = false;
//
//     // Payment successful - proceed with order placement
//     Get.snackbar(
//       'Payment Successful!',
//       'Payment ID: ${response.paymentId}',
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//
//     // Call your placeOrder function here
//     placeOrderAfterPayment(response.paymentId!);
//   }
//
//   void _handlePaymentFailure(PaymentFailureResponse response) {
//     _isPaymentProcessing.value = false;
//
//     Get.snackbar(
//       'Payment Failed',
//       'Error: ${response.code} - ${response.message}',
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     _isPaymentProcessing.value = false;
//
//     Get.snackbar(
//       'External Wallet',
//       'Wallet: ${response.walletName}',
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//     );
//   }
//
//   void initiateRazorpayPayment(double amount, String courseName) {
//     _isPaymentProcessing.value = true;
//
//     _razorpayService.openCheckout(
//       key: 'YOUR_RAZORPAY_KEY_ID', // Replace with your actual key
//       amount: amount,
//       currency: 'INR',
//       name: 'AuraTech Academy',
//       description: 'Payment for $courseName',
//       prefillEmail: 'student@email.com', // Get from user profile
//       prefillContact: '9413561917', // Get from user profile
//       notes: {
//         'course': courseName,
//         'student_id': 'YOUR_STUDENT_ID'
//       },
//     );
//   }
//
//   Future<void> placeOrderAfterPayment(String paymentId) async {
//     try {
//       isLoading.value = true;
//
//       // Your existing placeOrder logic, but now with payment ID
//       // Make API call to your backend with payment confirmation
//
//       // Example API call:
//       // final response = await apiService.placeOrder({
//       //   'payment_id': paymentId,
//       //   'amount': totalAmount,
//       //   'course_id': courseId,
//       // });
//
//       Get.offAll(() => BottomnavBar());
//
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to place order: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
//   final ApiService _apiService =
//       ApiService(baseUrl: "https://api.auratechacademy.com");
//
//
//
//   // Future<void> checkout({
//   //   required File? paymentScreenshot,
//   //   required int userId,
//   //   required String utr_no,
//   //   required List<int> cartitemIds, // ensure ints
//   //   required String firstName,
//   //   required String lastName,
//   //   required String countryName,
//   //   required String companyName,
//   //   required String streetAddress,
//   //   required String apartmentNo,
//   //   required String cityName,
//   //   required String postCode,
//   //   required String emailAddress,
//   //   required String phoneNumber,
//   // }) async {
//   //   isLoading.value = true;
//   //   errorMessage.value = "";
//   //   orderResponse.value = null;
//   //
//   //   final uri = Uri.parse("https://api.auratechacademy.com/orderdetail/");
//   //
//   //   try {
//   //     if (paymentScreenshot == null) {
//   //       throw Exception("Payment screenshot is missing");
//   //     }
//   //
//   //     final req = http.MultipartRequest('POST', uri);
//   //
//   //     // -------- FIELDS (snake_case + typos fixed) --------
//   //     final fields = <String, String>{
//   //       "user_id": userId.toString(),
//   //       // DO NOT put cartitem_ids here (Map overwrites duplicate keys)
//   //       "first_name": firstName,
//   //       "last_name": lastName,
//   //       "country_name": countryName,
//   //       "your_company_name": companyName,
//   //       "street_address": streetAddress,
//   //       "apartment_no": apartmentNo,
//   //       "city": cityName,
//   //       "postcode": postCode,
//   //       "email_address": emailAddress,
//   //       "phone_no": phoneNumber,
//   //       "utr_number": utr_no,
//   //     };
//   //     req.fields.addAll(fields);
//   //
//   //     // -------- cartitem_ids AS REPEATED FORM PARTS --------
//   //     // This creates multiple "cartitem_ids" text parts:
//   //     // cartitem_ids=110 & cartitem_ids=114 ...
//   //     for (final id in cartitemIds) {
//   //       req.files.add(
//   //         http.MultipartFile.fromString(
//   //           'cartitem_ids',
//   //           id.toString(),
//   //           contentType: MediaType('text', 'plain'), // optional
//   //         ),
//   //       );
//   //     }
//   //
//   //     // -------- FILE (payment_screenshot) --------
//   //     final fileName = p.basename(paymentScreenshot.path);
//   //     final imgPart = await http.MultipartFile.fromPath(
//   //       'payment_screenshot',
//   //       paymentScreenshot.path,
//   //     );
//   //     req.files.add(imgPart);
//   //
//   //     // -------- DEBUG: REQUEST SNAPSHOT --------
//   //     final filesMeta = req.files
//   //         .map((f) => {
//   //               "field": f.field,
//   //               "filename": f.filename, // null for text parts
//   //               "length": f.length,
//   //             })
//   //         .toList();
//   //
//   //     LogX.printLog("➡️  POST $uri");
//   //     LogX.printLog(
//   //         "➡️  Fields (no cartitem_ids here): ${const JsonEncoder.withIndent('  ').convert(fields)}");
//   //     LogX.printLog(
//   //         "➡️  Parts (including repeated cartitem_ids + image): ${const JsonEncoder.withIndent('  ').convert(filesMeta)}");
//   //
//   //     // Optional: cURL preview (shows cartitem_ids repeated)
//   //     final curl = _toCurlPreview(
//   //       url: uri.toString(),
//   //       fields: fields,
//   //       repeatedListField: 'cartitem_ids',
//   //       listValues: cartitemIds.map((e) => e.toString()).toList(),
//   //       fileField: 'payment_screenshot',
//   //       filePath: paymentScreenshot.path,
//   //       fileName: fileName,
//   //     );
//   //     LogX.printLog("➡️  cURL preview:\n$curl");
//   //
//   //     // -------- SEND --------
//   //     final streamedResponse = await req.send();
//   //     final response = await http.Response.fromStream(streamedResponse);
//   //
//   //     final prettyHeaders = const JsonEncoder.withIndent('  ')
//   //         .convert(response.headers.map((k, v) => MapEntry(k, v.toString())));
//   //     LogX.printLog("⬅️  Response ${response.statusCode}");
//   //     LogX.printLog("⬅️  Headers:\n$prettyHeaders");
//   //     LogX.printLog("⬅️  Body:\n${response.body}");
//   //
//   //     if (response.statusCode == 200 || response.statusCode == 201) {
//   //       final jsonResponse = jsonDecode(response.body);
//   //       orderResponse.value = OrderResponseModel.fromJson(jsonResponse);
//   //       LogX.printLog("✅ Order placed successfully");
//   //       Get.snackbar("Order Success ", "✅ Order placed successfully");
//   //       StorageService.saveData("refresh_profile", true);
//   //     } else {
//   //       errorMessage.value =
//   //           "Server returned ${response.statusCode}: ${response.body}";
//   //       LogX.printError(errorMessage.value);
//   //       Get.snackbar("Error", errorMessage.value);
//   //     }
//   //   } catch (e, st) {
//   //     errorMessage.value = "Checkout failed: ${e.toString()}";
//   //     LogX.printError("Checkout failed: ${e.toString()}\n$st");
//   //     Get.snackbar("Error", errorMessage.value);
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//
//  // ---- helper ----
//   String _toCurlPreview({
//     required String url,
//     required Map<String, String> fields,
//     required String repeatedListField,
//     required List<String> listValues,
//     required String fileField,
//     required String filePath,
//     required String fileName,
//   }) {
//     final buf = StringBuffer();
//     buf.writeln("curl -X POST '$url' \\");
//     fields.forEach((k, v) {
//       final safe = v.replaceAll("'", r"'\''");
//       buf.writeln("  -F '$k=$safe' \\");
//     });
//     for (final v in listValues) {
//       buf.writeln("  -F '$repeatedListField=$v' \\");
//     }
//     buf.writeln("  -F '$fileField=@$filePath;filename=$fileName'");
//     return buf.toString();
//   }
//



import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../widget/custombottombar.dart';
import '../../../ApiServices/razorpay_service.dart';
import '../../../utils/logx.dart';
import '../../../utils/storageservice.dart';
import '../Model/ChekoutModel.dart';

/// ==== CONFIG (अपने backend के हिसाब से बदलो) ====
const String kBaseUrl          = 'https://api.auratechacademy.com';
const String kOrderEndpoint    = '$kBaseUrl/orderdetail/';  // QR + Razorpay दोनों यहीं accept करा सकते हो
const String kRzpOrderEndpoint = '$kBaseUrl/payments/razorpay/create-order'; // OPTIONAL (server पर RZP order बनाओ)

/// UI से आया हुआ पूरा payload जिसे payment से पहले stash करेंगे
class OrderDraft {
  final int userId;
  final List<int> cartitemIds;
  final String firstName;
  final String lastName;
  final String countryName;
  final String companyName;
  final String streetAddress;
  final String apartmentNo;
  final String cityName;
  final String postCode;
  final String emailAddress;
  final String phoneNumber;
  final int amountRupee; // display total (₹)

  OrderDraft({
    required this.userId,
    required this.cartitemIds,
    required this.firstName,
    required this.lastName,
    required this.countryName,
    required this.companyName,
    required this.streetAddress,
    required this.apartmentNo,
    required this.cityName,
    required this.postCode,
    required this.emailAddress,
    required this.phoneNumber,
    required this.amountRupee,
  });

  Map<String, String> toFields({String paymentMode = 'offline'}) {
    return {
      'user_id': userId.toString(),
      'first_name': firstName,
      'last_name': lastName,
      'country_name': countryName,
      'your_company_name': companyName,
      'street_address': streetAddress,
      'apartment_no': apartmentNo,
      'city': cityName,
      'postcode': postCode,
      'email_address': emailAddress,
      'phone_no': phoneNumber,
      'payment_mode': paymentMode, // 'offline' | 'online'
    };
  }
}

class ChekoutController extends GetxController {
  // STATE
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final orderResponse = Rx<OrderResponseModel?>(null);

  // Payment
  final RazorpayService _rzp = RazorpayService();
  final isPaymentProcessing = false.obs;

  // UI -> stored draft for Razorpay success callback
  final Rx<OrderDraft?> _draft = Rx<OrderDraft?>(null);

  // Optionally store server-created Razorpay orderId
  String? _rzpOrderId;

  @override
  void onInit() {
    _rzp.initialize(
      onSuccess: _onRzpSuccess,
      onFailure: _onRzpFailure,
      onExternalWallet: _onRzpWallet,
    );
    super.onInit();
  }

  @override
  void onClose() {
    _rzp.dispose();
    super.onClose();
  }

  /// ====== PUBLIC: QR (UTR + Screenshot) Flow ======
  Future<void> checkoutWithQRCode({
    required File paymentScreenshot,
    required OrderDraft draft,
    required String utrNo,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    orderResponse.value = null;

    try {
      final uri = Uri.parse(kOrderEndpoint);
      final req = http.MultipartRequest('POST', uri);

      // fields
      final fields = {
        ...draft.toFields(paymentMode: 'offline'),
        'utr_number': utrNo,
        'payment_gateway': 'bank_qr',
      };
      req.fields.addAll(fields);

      // repeated cartitem_ids
      for (final id in draft.cartitemIds) {
        req.files.add(http.MultipartFile.fromString('cartitem_ids', id.toString()));
      }

      // file
      final fileName = p.basename(paymentScreenshot.path);
      req.files.add(await http.MultipartFile.fromPath(
        'payment_screenshot',
        paymentScreenshot.path,
        filename: fileName,
      ));

      _logRequest(req);

      final resp = await http.Response.fromStream(await req.send());
      _logResponse(resp);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final json = jsonDecode(resp.body);
        orderResponse.value = OrderResponseModel.fromJson(json);
        StorageService.saveData('refresh_profile', true);
        Get.snackbar('Order Success', '✅ Order placed successfully');
        Get.offAll(() => BottomnavBar());
      } else {
        throw Exception('Server ${resp.statusCode}: ${resp.body}');
      }
    } catch (e, st) {
      errorMessage.value = 'Checkout (QR) failed: $e';
      LogX.printError('[QR] $e\n$st');
      Get.snackbar('Error', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// ====== PUBLIC: Start Razorpay Flow (open checkout) ======
  /// स्क्रीन से पहले draft set करो, फिर (optional) server पर RZP order बनाओ, फिर openCheckout
  Future<void> startRazorpay({
    required OrderDraft draft,
    required String rzpKey,
    bool createOrderOnServer = true,
  }) async {
    _draft.value = draft;
    isPaymentProcessing.value = true;

    try {
      String? orderId;
      int amountPaise = draft.amountRupee * 100;

      if (createOrderOnServer) {
        final order = await createRzpOrderOnServer(
          amountPaise: amountPaise,
          currency: 'INR',
          receipt: 'rcpt_${DateTime.now().millisecondsSinceEpoch}',
        );
        orderId = order['order_id'] as String?;
        if (orderId != null) _rzpOrderId = orderId;
      }

      _rzp.openCheckout(
        key: rzpKey,
        amountPaise: amountPaise,
        currency: 'INR',
        name: 'AuraTech Academy',
        description: 'Course Purchase',
        orderId: orderId,
        prefillEmail: draft.emailAddress,
        prefillContact: draft.phoneNumber,
        notes: {
          'user_id': draft.userId.toString(),
          'cart_count': draft.cartitemIds.length.toString(),
        },
        enableUPI: true,
        enableCard: true,
        enableNetbanking: true,
        enableWallet: true,
      );
    } catch (e, st) {
      isPaymentProcessing.value = false;
      Get.snackbar('Razorpay Error', '$e',
          backgroundColor: Colors.red, colorText: Colors.white);
      LogX.printError('[RZP open] $e\n$st');
    }
  }

  /// OPTIONAL: Backend पर Razorpay order बनवाने के लिए
  Future<Map<String, dynamic>> createRzpOrderOnServer({
    required int amountPaise,
    required String currency,
    required String receipt,
  }) async {
    final uri = Uri.parse(kRzpOrderEndpoint);
    LogX.printLog('➡️ POST $uri (create rzp order)');

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amountPaise,
        'currency': currency,
        'receipt': receipt,
      }),
    );

    LogX.printLog('⬅️ ${resp.statusCode} ${resp.body}');
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create rzp order: ${resp.statusCode}: ${resp.body}');
  }

  /// ====== PRIVATE: Razorpay Callbacks ======
  void _onRzpSuccess(PaymentSuccessResponse r) async {
    isPaymentProcessing.value = false;
    Get.snackbar('Payment Successful', 'Payment: ${r.paymentId}',
        backgroundColor: Colors.green, colorText: Colors.white);

    final draft = _draft.value;
    if (draft == null) {
      Get.snackbar('Order Error', 'Draft missing, cannot place order',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    await checkoutWithRazorpay(
      draft: draft,
      razorpayPaymentId: r.paymentId ?? '',
      razorpayOrderId: r.orderId ?? _rzpOrderId,
      razorpaySignature: r.signature, // कुछ SDK versions में मिलता है
    );
  }

  void _onRzpFailure(PaymentFailureResponse r) {
    isPaymentProcessing.value = false;
    Get.snackbar('Payment Failed', '${r.code}: ${r.message}',
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _onRzpWallet(ExternalWalletResponse r) {
    isPaymentProcessing.value = false;
    Get.snackbar('External Wallet', '${r.walletName}',
        backgroundColor: Colors.orange, colorText: Colors.white);
  }

  /// ====== ONLINE: Payment success के बाद order place ======
  Future<void> checkoutWithRazorpay({
    required OrderDraft draft,
    required String razorpayPaymentId,
    String? razorpayOrderId,
    String? razorpaySignature,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    orderResponse.value = null;

    try {
      final uri = Uri.parse(kOrderEndpoint);
      final req = http.MultipartRequest('POST', uri);

      // basic fields + payment meta
      final fields = {
        ...draft.toFields(paymentMode: 'online'),
        'payment_gateway': 'razorpay',
        'razorpay_payment_id': razorpayPaymentId,
        if (razorpayOrderId != null) 'razorpay_order_id': razorpayOrderId,
        if (razorpaySignature != null) 'razorpay_signature': razorpaySignature,
        // (optional) तुम चाहो तो amount भी भेजो verify के लिए
        'amount_rupee': draft.amountRupee.toString(),
      };
      req.fields.addAll(fields);

      // repeated cart ids
      for (final id in draft.cartitemIds) {
        req.files.add(http.MultipartFile.fromString('cartitem_ids', id.toString()));
      }

      _logRequest(req);

      final resp = await http.Response.fromStream(await req.send());
      _logResponse(resp);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final json = jsonDecode(resp.body);
        orderResponse.value = OrderResponseModel.fromJson(json);
        StorageService.saveData('refresh_profile', true);
        Get.snackbar('Order Success', '✅ Order placed successfully');
        Get.offAll(() => BottomnavBar());
      } else {
        throw Exception('Server ${resp.statusCode}: ${resp.body}');
      }
    } catch (e, st) {
      errorMessage.value = 'Checkout (Razorpay) failed: $e';
      LogX.printError('[RZP place] $e\n$st');
      Get.snackbar('Error', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ====== logs helpers ======
  void _logRequest(http.MultipartRequest req) {
    final filesMeta = req.files
        .map((f) => {'field': f.field, 'filename': f.filename, 'length': f.length})
        .toList();
    LogX.printLog('➡️ POST ${req.url}');
    LogX.printLog('➡️ Fields: ${const JsonEncoder.withIndent("  ").convert(req.fields)}');
    LogX.printLog('➡️ Parts: ${const JsonEncoder.withIndent("  ").convert(filesMeta)}');
  }

  void _logResponse(http.Response resp) {
    final prettyHeaders = const JsonEncoder.withIndent('  ')
        .convert(resp.headers.map((k, v) => MapEntry(k, v.toString())));
    LogX.printLog('⬅️ Status: ${resp.statusCode}');
    LogX.printLog('⬅️ Headers:\n$prettyHeaders');
    LogX.printLog('⬅️ Body:\n${resp.body}');
  }
}
