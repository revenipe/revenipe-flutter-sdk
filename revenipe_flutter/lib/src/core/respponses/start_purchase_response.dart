import 'package:revenipe_flutter/revenipe_flutter.dart';

class StartPurchaseResponse {
  final String purchaseMethod;
  final String productId;
  final String productType;
  final CheckoutPurchase? checkout;
  final PaymentSheetPurchase? paymentSheet;
  final SetupPurchase? setup;
  final StartSubscriptionPurchase? subscription;

  const StartPurchaseResponse({
    required this.purchaseMethod,
    required this.productId,
    required this.productType,
    this.checkout,
    this.paymentSheet,
    this.setup,
    this.subscription,
  });

  factory StartPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return StartPurchaseResponse(
      purchaseMethod: json['purchase_method'] as String,
      productId: json['product_id'] as String,
      productType: json['product_type'] as String,
      checkout: json['checkout'] == null
          ? null
          : CheckoutPurchase.fromJson(json['checkout'] as Map<String, dynamic>),
      paymentSheet: json['payment_sheet'] == null
          ? null
          : PaymentSheetPurchase.fromJson(
              json['payment_sheet'] as Map<String, dynamic>,
            ),
      setup: json['setup'] == null
          ? null
          : SetupPurchase.fromJson(json['setup'] as Map<String, dynamic>),
      subscription: json['subscription'] == null
          ? null
          : StartSubscriptionPurchase.fromJson(
              json['subscription'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchase_method': purchaseMethod,
      'product_id': productId,
      'product_type': productType,
      'checkout': checkout?.toJson(),
      'payment_sheet': paymentSheet?.toJson(),
    };
  }
}
