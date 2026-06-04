import 'package:revenipe_flutter/revenipe_flutter.dart';

class AttachPaymentMethodToSubscriptionResponse {
  const AttachPaymentMethodToSubscriptionResponse({
    required this.purchaseMethod,
    this.checkout,
    this.paymentSheet,
  });

  final RevenipePurchaseMethod purchaseMethod;
  final CheckoutPurchase? checkout;
  final PaymentSheetPurchase? paymentSheet;

  bool get isCheckout => checkout != null;

  bool get isPaymentSheet => paymentSheet != null;

  factory AttachPaymentMethodToSubscriptionResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final purchaseMethodValue = json['mode'] as String;

    return AttachPaymentMethodToSubscriptionResponse(
      purchaseMethod: RevenipePurchaseMethod.values.firstWhere(
        (method) => method.value == purchaseMethodValue,
        orElse: () => throw FormatException(
          'Unsupported purchase method: $purchaseMethodValue',
        ),
      ),
      checkout: json['checkout'] == null
          ? null
          : CheckoutPurchase.fromJson(json['checkout'] as Map<String, dynamic>),
      paymentSheet: json['payment_sheet'] == null
          ? null
          : PaymentSheetPurchase.fromJson(
              json['payment_sheet'] as Map<String, dynamic>,
            ),
    );
  }
}
