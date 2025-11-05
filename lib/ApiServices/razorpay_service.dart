// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class RazorpayService {
//   late Razorpay _razorpay;
//   Function(PaymentSuccessResponse)? onSuccess;
//   Function(PaymentFailureResponse)? onFailure;
//   Function(ExternalWalletResponse)? onExternalWallet;
//
//   void initialize({
//     required Function(PaymentSuccessResponse) onSuccess,
//     required Function(PaymentFailureResponse) onFailure,
//     required Function(ExternalWalletResponse) onExternalWallet,
//   }) {
//     this.onSuccess = onSuccess;
//     this.onFailure = onFailure;
//     this.onExternalWallet = onExternalWallet;
//
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     if (onSuccess != null) {
//       onSuccess!(response);
//     }
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     if (onFailure != null) {
//       onFailure!(response);
//     }
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     if (onExternalWallet != null) {
//       onExternalWallet!(response);
//     }
//   }
//
//   void openCheckout({
//     required String key,
//     required double amount,
//     required String currency,
//     required String name,
//     required String description,
//     String? prefillEmail,
//     String? prefillContact,
//     Map<String, dynamic>? notes,
//   }) {
//     final options = {
//       'key': key,
//       'amount': (amount * 100).round(), // Convert to paise
//       'name': name,
//       'description': description,
//       'prefill': {
//         'contact': prefillContact ?? '',
//         'email': prefillEmail ?? ''
//       },
//       'notes': notes ?? {},
//       'currency': currency,
//       'theme': {'color': '#007AFF'},
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       print('Razorpay Error: $e');
//     }
//   }
//
//   void dispose() {
//     _razorpay.clear();
//   }
// }







import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/foundation.dart';

class RazorpayService {
  late Razorpay _razorpay;
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;
  Function(ExternalWalletResponse)? onExternalWallet;

  void initialize({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    this.onSuccess = onSuccess;
    this.onFailure = onFailure;
    this.onExternalWallet = onExternalWallet;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required String key,
    required int amountPaise, // paise
    required String currency,
    required String name,
    required String description,
    String? orderId,          // server-created RZP order id (recommended)
    String? prefillEmail,
    String? prefillContact,
    Map<String, dynamic>? notes,
    bool enableUPI = true,
    bool enableCard = true,
    bool enableNetbanking = true,
    bool enableWallet = true,
  }) {
    final options = {
      'key': key,
      'amount': amountPaise,
      'currency': currency,
      'name': name,
      'description': description,
      if (orderId != null) 'order_id': orderId,
      'prefill': {
        'contact': prefillContact ?? '',
        'email': prefillEmail ?? '',
      },
      'notes': notes ?? {},
      'method': {
        'upi': enableUPI,
        'card': enableCard,
        'netbanking': enableNetbanking,
        'wallet': enableWallet,
      },
      'theme': {'color': '#007AFF'},
    };

    try {
      if (kDebugMode) debugPrint('[RZP] openCheckout options: $options');
      _razorpay.open(options);
    } catch (e) {
      if (kDebugMode) debugPrint('[RZP] open error: $e');
      rethrow;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse r) {
    onSuccess?.call(r);
  }

  void _handlePaymentError(PaymentFailureResponse r) {
    onFailure?.call(r);
  }

  void _handleExternalWallet(ExternalWalletResponse r) {
    onExternalWallet?.call(r);
  }

  void dispose() {
    _razorpay.clear();
  }
}
