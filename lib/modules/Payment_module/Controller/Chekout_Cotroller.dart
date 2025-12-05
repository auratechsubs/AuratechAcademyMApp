//kam krta hua model
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as p;
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// import '../../../widget/custombottombar.dart';
// import '../../../ApiServices/razorpay_service.dart';
// import '../../../utils/logx.dart';
// import '../../../utils/storageservice.dart';
// import '../Model/ChekoutModel.dart';
//
// /// ==== CONFIG (अपने backend के हिसाब से बदलो) ====
// const String kBaseUrl          = 'https://api.auratechacademy.com';
// const String kOrderEndpoint    = '$kBaseUrl/orderdetail/';  // QR + Razorpay दोनों यहीं accept करा सकते हो
// const String kRzpOrderEndpoint = '$kBaseUrl/payments/razorpay/create-order'; // OPTIONAL (server पर RZP order बनाओ)
//
// /// UI से आया हुआ पूरा payload जिसे payment से पहले stash करेंगे
// class OrderDraft {
//   final int userId;
//   final List<int> cartitemIds;
//   final String firstName;
//   final String lastName;
//   final String countryName;
//   final String companyName;
//   final String streetAddress;
//   final String apartmentNo;
//   final String cityName;
//   final String postCode;
//   final String emailAddress;
//   final String phoneNumber;
//   final int amountRupee; // display total (₹)
//
//   OrderDraft({
//     required this.userId,
//     required this.cartitemIds,
//     required this.firstName,
//     required this.lastName,
//     required this.countryName,
//     required this.companyName,
//     required this.streetAddress,
//     required this.apartmentNo,
//     required this.cityName,
//     required this.postCode,
//     required this.emailAddress,
//     required this.phoneNumber,
//     required this.amountRupee,
//   });
//
//   Map<String, String> toFields({String paymentMode = 'offline'}) {
//     return {
//       'user_id': userId.toString(),
//       'first_name': firstName,
//       'last_name': lastName,
//       'country_name': countryName,
//       'your_company_name': companyName,
//       'street_address': streetAddress,
//       'apartment_no': apartmentNo,
//       'city': cityName,
//       'postcode': postCode,
//       'email_address': emailAddress,
//       'phone_no': phoneNumber,
//       'payment_mode': paymentMode, // 'offline' | 'online'
//     };
//   }
// }
//
// class ChekoutController extends GetxController {
//   // STATE
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//   final orderResponse = Rx<OrderResponseModel?>(null);
//
//   // Payment
//   final RazorpayService _rzp = RazorpayService();
//   final isPaymentProcessing = false.obs;
//
//   // UI -> stored draft for Razorpay success callback
//   final Rx<OrderDraft?> _draft = Rx<OrderDraft?>(null);
//
//   // Optionally store server-created Razorpay orderId
//   String? _rzpOrderId;
//
//   @override
//   void onInit() {
//     _rzp.initialize(
//       onSuccess: _onRzpSuccess,
//       onFailure: _onRzpFailure,
//       onExternalWallet: _onRzpWallet,
//     );
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     _rzp.dispose();
//     super.onClose();
//   }
//
//   /// ====== PUBLIC: QR (UTR + Screenshot) Flow ======
//   Future<void> checkoutWithQRCode({
//     required File paymentScreenshot,
//     required OrderDraft draft,
//     required String utrNo,
//   }) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     orderResponse.value = null;
//
//     try {
//       final uri = Uri.parse(kOrderEndpoint);
//       final req = http.MultipartRequest('POST', uri);
//
//       // fields
//       final fields = {
//         ...draft.toFields(paymentMode: 'offline'),
//         'utr_number': utrNo,
//         'payment_gateway': 'bank_qr',
//       };
//       req.fields.addAll(fields);
//
//       // repeated cartitem_ids
//       for (final id in draft.cartitemIds) {
//         req.files.add(http.MultipartFile.fromString('cartitem_ids', id.toString()));
//       }
//
//       // file
//       final fileName = p.basename(paymentScreenshot.path);
//       req.files.add(await http.MultipartFile.fromPath(
//         'payment_screenshot',
//         paymentScreenshot.path,
//         filename: fileName,
//       ));
//
//       _logRequest(req);
//
//       final resp = await http.Response.fromStream(await req.send());
//       _logResponse(resp);
//
//       if (resp.statusCode == 200 || resp.statusCode == 201) {
//         final json = jsonDecode(resp.body);
//         orderResponse.value = OrderResponseModel.fromJson(json);
//         StorageService.saveData('refresh_profile', true);
//         Get.snackbar('Order Success', '✅ Order placed successfully');
//         Get.offAll(() => BottomnavBar());
//       } else {
//         throw Exception('Server ${resp.statusCode}: ${resp.body}');
//       }
//     } catch (e, st) {
//       errorMessage.value = 'Checkout (QR) failed: $e';
//       LogX.printError('[QR] $e\n$st');
//       Get.snackbar('Error', errorMessage.value,
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// ====== PUBLIC: Start Razorpay Flow (open checkout) ======
//   /// स्क्रीन से पहले draft set करो, फिर (optional) server पर RZP order बनाओ, फिर openCheckout
//   Future<void> startRazorpay({
//     required OrderDraft draft,
//     required String rzpKey,
//     bool createOrderOnServer = true,
//   }) async {
//     _draft.value = draft;
//     isPaymentProcessing.value = true;
//
//     try {
//       String? orderId;
//       int amountPaise = draft.amountRupee * 100;
//
//       if (createOrderOnServer) {
//         final order = await createRzpOrderOnServer(
//           amountPaise: amountPaise,
//           currency: 'INR',
//           receipt: 'rcpt_${DateTime.now().millisecondsSinceEpoch}',
//         );
//         orderId = order['order_id'] as String?;
//         if (orderId != null) _rzpOrderId = orderId;
//       }
//
//       _rzp.openCheckout(
//         key: rzpKey,
//         amountPaise: amountPaise,
//         currency: 'INR',
//         name: 'AuraTech Academy',
//         description: 'Course Purchase',
//         orderId: orderId,
//         prefillEmail: draft.emailAddress,
//         prefillContact: draft.phoneNumber,
//         notes: {
//           'user_id': draft.userId.toString(),
//           'cart_count': draft.cartitemIds.length.toString(),
//         },
//         enableUPI: true,
//         enableCard: true,
//         enableNetbanking: true,
//         enableWallet: true,
//       );
//     } catch (e, st) {
//       isPaymentProcessing.value = false;
//       Get.snackbar('Razorpay Error', '$e',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       LogX.printError('[RZP open] $e\n$st');
//     }
//   }
//
//   /// OPTIONAL: Backend पर Razorpay order बनवाने के लिए
//   Future<Map<String, dynamic>> createRzpOrderOnServer({
//     required int amountPaise,
//     required String currency,
//     required String receipt,
//   }) async {
//     final uri = Uri.parse(kRzpOrderEndpoint);
//     LogX.printLog('➡️ POST $uri (create rzp order)');
//
//     final resp = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'amount': amountPaise,
//         'currency': currency,
//         'receipt': receipt,
//       }),
//     );
//
//     LogX.printLog('⬅️ ${resp.statusCode} ${resp.body}');
//     if (resp.statusCode == 200 || resp.statusCode == 201) {
//       return jsonDecode(resp.body) as Map<String, dynamic>;
//     }
//     throw Exception('Failed to create rzp order: ${resp.statusCode}: ${resp.body}');
//   }
//
//   /// ====== PRIVATE: Razorpay Callbacks ======
//   void _onRzpSuccess(PaymentSuccessResponse r) async {
//     isPaymentProcessing.value = false;
//     Get.snackbar('Payment Successful', 'Payment: ${r.paymentId}',
//         backgroundColor: Colors.green, colorText: Colors.white);
//
//     final draft = _draft.value;
//     if (draft == null) {
//       Get.snackbar('Order Error', 'Draft missing, cannot place order',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return;
//     }
//
//     await checkoutWithRazorpay(
//       draft: draft,
//       razorpayPaymentId: r.paymentId ?? '',
//       razorpayOrderId: r.orderId ?? _rzpOrderId,
//       razorpaySignature: r.signature, // कुछ SDK versions में मिलता है
//     );
//   }
//
//   void _onRzpFailure(PaymentFailureResponse r) {
//     isPaymentProcessing.value = false;
//     Get.snackbar('Payment Failed', '${r.code}: ${r.message}',
//         backgroundColor: Colors.red, colorText: Colors.white);
//   }
//
//   void _onRzpWallet(ExternalWalletResponse r) {
//     isPaymentProcessing.value = false;
//     Get.snackbar('External Wallet', '${r.walletName}',
//         backgroundColor: Colors.orange, colorText: Colors.white);
//   }
//
//   /// ====== ONLINE: Payment success के बाद order place ======
//   Future<void> checkoutWithRazorpay({
//     required OrderDraft draft,
//     required String razorpayPaymentId,
//     String? razorpayOrderId,
//     String? razorpaySignature,
//   }) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     orderResponse.value = null;
//
//     try {
//       final uri = Uri.parse(kOrderEndpoint);
//       final req = http.MultipartRequest('POST', uri);
//
//       // basic fields + payment meta
//       final fields = {
//         ...draft.toFields(paymentMode: 'online'),
//         'payment_gateway': 'razorpay',
//         'razorpay_payment_id': razorpayPaymentId,
//         if (razorpayOrderId != null) 'razorpay_order_id': razorpayOrderId,
//         if (razorpaySignature != null) 'razorpay_signature': razorpaySignature,
//         // (optional) तुम चाहो तो amount भी भेजो verify के लिए
//         'amount_rupee': draft.amountRupee.toString(),
//       };
//       req.fields.addAll(fields);
//
//       // repeated cart ids
//       for (final id in draft.cartitemIds) {
//         req.files.add(http.MultipartFile.fromString('cartitem_ids', id.toString()));
//       }
//
//       _logRequest(req);
//
//       final resp = await http.Response.fromStream(await req.send());
//       _logResponse(resp);
//
//       if (resp.statusCode == 200 || resp.statusCode == 201) {
//         final json = jsonDecode(resp.body);
//         orderResponse.value = OrderResponseModel.fromJson(json);
//         StorageService.saveData('refresh_profile', true);
//         Get.snackbar('Order Success', '✅ Order placed successfully');
//         Get.offAll(() => BottomnavBar());
//       } else {
//         throw Exception('Server ${resp.statusCode}: ${resp.body}');
//       }
//     } catch (e, st) {
//       errorMessage.value = 'Checkout (Razorpay) failed: $e';
//       LogX.printError('[RZP place] $e\n$st');
//       Get.snackbar('Error', errorMessage.value,
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ====== logs helpers ======
//   void _logRequest(http.MultipartRequest req) {
//     final filesMeta = req.files
//         .map((f) => {'field': f.field, 'filename': f.filename, 'length': f.length})
//         .toList();
//     LogX.printLog('➡️ POST ${req.url}');
//     LogX.printLog('➡️ Fields: ${const JsonEncoder.withIndent("  ").convert(req.fields)}');
//     LogX.printLog('➡️ Parts: ${const JsonEncoder.withIndent("  ").convert(filesMeta)}');
//   }
//
//   void _logResponse(http.Response resp) {
//     final prettyHeaders = const JsonEncoder.withIndent('  ')
//         .convert(resp.headers.map((k, v) => MapEntry(k, v.toString())));
//     LogX.printLog('⬅️ Status: ${resp.statusCode}');
//     LogX.printLog('⬅️ Headers:\n$prettyHeaders');
//     LogX.printLog('⬅️ Body:\n${resp.body}');
//   }
// }

// new Controller for new order master api

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:auratech_academy/ApiServices/ApiServices.dart';
import 'package:auratech_academy/ApiServices/razorpay_service.dart';
import 'package:auratech_academy/modules/Payment_module/Model/ChekoutModel.dart';
import 'package:auratech_academy/utils/logx.dart';
import 'package:auratech_academy/utils/storageservice.dart';
import 'package:auratech_academy/widget/custombottombar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// ==== BASE CONFIG (backend ke hisaab se) ====
const String _kBaseUrl = 'https://api.auratechacademy.com';
const String _kOrderDetailEndpoint = 'orderdetail/'; // QR + Razorpay detail API
const String _kRzpOrderEndpoint = 'payments/razorpay/create-order'; // optional

/// UI se aaya hua payload jo payment se pehle stash karte hain
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
  final int amountRupee; // ₹ total

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

  /// fields jo tumhari orderdetail API expect karti hai
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

  @override
  String toString() {
    return 'OrderDraft(userId:$userId, items:${cartitemIds.length}, amount:$amountRupee, name:$firstName $lastName, email:$emailAddress, phone:$phoneNumber)';
  }
}

class ChekoutController extends GetxController {
  // 🔹 Api service instance (JSON-based order_master ke liye)
  final ApiService _api = ApiService(
    baseUrl: 'https://api.auratechacademy.com/',
  );

  // 🔹 State
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // 🔹 order_master (JSON) ka last created order
  final Rxn<OrderDataModel> createdOrder = Rxn<OrderDataModel>();

  // 🔹 orderdetail (multipart) ka response (QR/Razorpay)
  final Rx<OrderCreateResponseModel?> orderResponse =
      Rx<OrderCreateResponseModel?>(null);

  // 🔹 Payment state
  final RazorpayService _rzp = RazorpayService();
  final RxBool isPaymentProcessing = false.obs;

  // 🔹 UI se aaya draft (Razorpay success callback ke liye)
  final Rx<OrderDraft?> _draft = Rx<OrderDraft?>(null);

  // OPTIONAL: server-created Razorpay orderId store karne ke liye
  String? _rzpOrderId;

  // 🔹 order_master endpoint (JSON)
  final String _createOrderEndpoint = 'order_master/';

  @override
  void onInit() {
    super.onInit();
    _rzp.initialize(
      onSuccess: _onRzpSuccess,
      onFailure: _onRzpFailure,
      onExternalWallet: _onRzpWallet,
    );
  }

  @override
  void onClose() {
    _rzp.dispose();
    super.onClose();
  }

  // =======================================================================
  // 1️⃣ order_master (JSON) – ApiService.post se
  // =======================================================================

  /// Create order on server using POST (order_master/)
   Future<void> createOrder({
    required int userId,
    required String date,
    required String orderFrom,
    required String itemCount,
    required String totalQty,
    required String totalAmt,
    required String taxType,
    required String igst,
    String? cgst,
    String? scgst,
    required String otherCharges,
    required String discountAmt,
    required String couponCode,
    required String netAmt,
    required String billingName,
    required String billingAddress,
    required String gstType,
    required String gstStateCode,
    required String description,
    required bool orderStatus,
    required String paymentMode,
    required String paymentResponse,
    required bool paymentStatus,
    String? remarks,
    String? extra,

    /// ✅ naya: creator ids
    // required int createUser,
    // required int updateUser,

    /// ✅ naya: order_details list (single / multiple dono case cover)
    required List<OrderDetailCreateModel> orderDetails,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    createdOrder.value = null;

    final Map<String, dynamic> body = {
      "user_id": userId,
      "date": date,
      "order_from": orderFrom,
      "item_count": itemCount,
      "total_qty": totalQty,
      "total_amt": totalAmt,
      "tax_type": taxType,
      "igst": igst,
      "cgst": cgst,
      "scgst": scgst,
      "other_charges": otherCharges,
      "discount_amt": discountAmt,
      "coupon_code": couponCode,
      "net_amt": netAmt,
      "billing_name": billingName,
      "billing_address": billingAddress,
      "gst_type": gstType,
      "gst_statecode": gstStateCode,
      "description": description,
      "order_status": orderStatus,
      "payment_mode": paymentMode,
      "payment_response": paymentResponse,
      "payment_Status": paymentStatus,
      "remarks": remarks,
      "extra": extra,

      /// 🔥 yahi woh do fields jo Postman me 1 the
      // "create_user": createUser,
      // "update_user": updateUser,

      /// 🔥 sabse important part: nested details
      "order_details": orderDetails.map((e) => e.toJson()).toList(),
    };

    try {
      LogX.printLog(
          "📡 [ChekoutController] POST (JSON) -> $_createOrderEndpoint");

      LogX.printLog(
          "📦 [ChekoutController] Request Body:\n${const JsonEncoder.withIndent('  ').convert(body)}");

      LogX.printLog(
          "📦 [ChekoutController] order_details length: ${orderDetails.length}");

      final OrderCreateResponseModel response =
      await _api.post<OrderCreateResponseModel>(
        _createOrderEndpoint,
        body,
            (json) => OrderCreateResponseModel.fromJson(json),
      );

      LogX.printLog(
          "⬅️ [ChekoutController] order_master raw response:\n${const JsonEncoder.withIndent('  ').convert(response.toJson())}");

      if (response.data != null) {
        createdOrder.value = response.data;
        LogX.printLog(
          "✅ [ChekoutController] order_master created. "
              "ID: ${response.data!.id}, Net Amount: ${response.data!.net_amt}",
        );
      } else {
        LogX.printWarning(
          "⚠️ [ChekoutController] POST success but 'data' is null. Raw: ${response.raw}",
        );
      }
    } catch (e, stackTrace) {
      errorMessage.value = e.toString();
      LogX.printError("❌ [ChekoutController] Error creating order: $e");
      LogX.printError("📌 [ChekoutController] StackTrace:\n$stackTrace");
    } finally {
      isLoading.value = false;
    }
  }


  // =======================================================================
  // 2️⃣ QR / UTR FLOW – orderdetail/ + screenshot (multipart)
  // =======================================================================

  Future<void> checkoutWithQRCode({
    required File paymentScreenshot,
    required OrderDraft draft,
    required String utrNo,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    orderResponse.value = null;

    try {
      final uri = Uri.parse('$_kBaseUrl/$_kOrderDetailEndpoint');
      final req = http.MultipartRequest('POST', uri);

      final fields = {
        ...draft.toFields(paymentMode: 'offline'),
        'utr_number': utrNo,
        'payment_gateway': 'bank_qr',
      };
      req.fields.addAll(fields);

      for (final id in draft.cartitemIds) {
        req.files.add(http.MultipartFile.fromString(
          'cartitem_ids',
          id.toString(),
        ));
      }

      // file
      final fileName = p.basename(paymentScreenshot.path);
      req.files.add(await http.MultipartFile.fromPath(
        'payment_screenshot',
        paymentScreenshot.path,
        filename: fileName,
      ));

      _logRequest(req, tag: 'QR');

      final resp = await http.Response.fromStream(await req.send());
      _logResponse(resp, tag: 'QR');

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final json = jsonDecode(resp.body);
        orderResponse.value = OrderCreateResponseModel.fromJson(json);
        StorageService.saveData('refresh_profile', true);

        Get.snackbar('Order Success', '✅ Order placed successfully');
        Get.offAll(() => const BottomnavBar());
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

  // =======================================================================
  // 3️⃣ RAZORPAY FLOW – start + callbacks + orderdetail/
  // =======================================================================

  Future<void> startRazorpay({
    required OrderDraft draft,
    required String rzpKey,
    bool createOrderOnServer = true,
  }) async {
    _draft.value = draft;
    isPaymentProcessing.value = true;

    try {
      String? orderId;
      final int amountPaise = draft.amountRupee * 100;

      if (createOrderOnServer) {
        final order = await createRzpOrderOnServer(
          amountPaise: amountPaise,
          currency: 'INR',
          receipt: 'rcpt_${DateTime.now().millisecondsSinceEpoch}',
        );
        orderId = order['order_id'] as String?;
        if (orderId != null) _rzpOrderId = orderId;
      }

      LogX.printLog(
          "📲 [ChekoutController] Opening Razorpay, amount_paise: $amountPaise, orderId: $orderId");

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

  Future<Map<String, dynamic>> createRzpOrderOnServer({
    required int amountPaise,
    required String currency,
    required String receipt,
  }) async {
    final uri = Uri.parse('$_kBaseUrl/$_kRzpOrderEndpoint');
    LogX.printLog('➡️ [ChekoutController] POST $uri (create rzp order)');

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amountPaise,
        'currency': currency,
        'receipt': receipt,
      }),
    );

    LogX.printLog(
        '⬅️ [ChekoutController] RZP order status: ${resp.statusCode}');
    LogX.printLog('⬅️ [ChekoutController] RZP order body: ${resp.body}');

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception(
        'Failed to create rzp order: ${resp.statusCode}: ${resp.body}');
  }

  void _onRzpSuccess(PaymentSuccessResponse r) async {
    isPaymentProcessing.value = false;
    LogX.printLog(
        "[RZP] ✅ Success: paymentId=${r.paymentId}, orderId=${r.orderId}, sig=${r.signature}");
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
      razorpaySignature: r.signature,
    );
  }

  void _onRzpFailure(PaymentFailureResponse r) {
    isPaymentProcessing.value = false;
    LogX.printError(
        "[RZP] ❌ Failure: code=${r.code}, message=${r.message}, error=${r.error}");
    Get.snackbar('Payment Failed', '${r.code}: ${r.message}',
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _onRzpWallet(ExternalWalletResponse r) {
    isPaymentProcessing.value = false;
    LogX.printLog("[RZP] 💼 External wallet: ${r.walletName}");
    Get.snackbar('External Wallet', '${r.walletName}',
        backgroundColor: Colors.orange, colorText: Colors.white);
  }

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
      final uri = Uri.parse('$_kBaseUrl/$_kOrderDetailEndpoint');
      final req = http.MultipartRequest('POST', uri);

      final fields = {
        ...draft.toFields(paymentMode: 'online'),
        'payment_gateway': 'razorpay',
        'razorpay_payment_id': razorpayPaymentId,
        if (razorpayOrderId != null) 'razorpay_order_id': razorpayOrderId,
        if (razorpaySignature != null) 'razorpay_signature': razorpaySignature,
        'amount_rupee': draft.amountRupee.toString(),
      };
      req.fields.addAll(fields);

      for (final id in draft.cartitemIds) {
        req.files.add(http.MultipartFile.fromString(
          'cartitem_ids',
          id.toString(),
        ));
      }

      _logRequest(req, tag: 'RZP');

      final resp = await http.Response.fromStream(await req.send());
      _logResponse(resp, tag: 'RZP');

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final json = jsonDecode(resp.body);
        orderResponse.value = OrderCreateResponseModel.fromJson(json);
        StorageService.saveData('refresh_profile', true);

        Get.snackbar('Order Success', '✅ Order placed successfully');
        Get.offAll(() => const BottomnavBar());
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

  // =======================================================================
  // 4️⃣ Logging helpers
  // =======================================================================

  void _logRequest(http.MultipartRequest req, {String tag = ''}) {
    final filesMeta = req.files
        .map((f) => {
              'field': f.field,
              'filename': f.filename,
              'length': f.length,
            })
        .toList();
    LogX.printLog('➡️ [$tag] POST ${req.url}');
    LogX.printLog(
        '➡️ [$tag] Fields:\n${const JsonEncoder.withIndent("  ").convert(req.fields)}');
    LogX.printLog(
        '➡️ [$tag] Parts:\n${const JsonEncoder.withIndent("  ").convert(filesMeta)}');
  }

  void _logResponse(http.Response resp, {String tag = ''}) {
    final prettyHeaders = const JsonEncoder.withIndent('  ')
        .convert(resp.headers.map((k, v) => MapEntry(k, v.toString())));
    LogX.printLog('⬅️ [$tag] Status: ${resp.statusCode}');
    LogX.printLog('⬅️ [$tag] Headers:\n$prettyHeaders');
    LogX.printLog('⬅️ [$tag] Body:\n${resp.body}');
  }
}
