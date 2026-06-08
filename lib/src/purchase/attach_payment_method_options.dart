import 'package:revenipe_flutter/src/purchase/purchase_method.dart';

class AttachPaymentMethodOptions {
  final RevenipePurchaseMethod method;
  final String? successUrl;
  final String? cancelUrl;

  const AttachPaymentMethodOptions({
    required this.method,
    this.successUrl,
    this.cancelUrl,
  });
}
