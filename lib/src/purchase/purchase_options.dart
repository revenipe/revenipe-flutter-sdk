import 'package:revenipe_flutter/src/purchase/purchase_method.dart';
import 'package:revenipe_flutter/src/purchase/trial_payment_behavior.dart';

class MakePurchaseOptions {
  final String productId;
  final RevenipePurchaseMethod method;
  final String? successUrl;
  final String? cancelUrl;
  final Map<String, String>? extraParams;
  final String customerId;
  final TrialPaymentMethodBehavior? trialPaymentMethodBehavior;

  const MakePurchaseOptions({
    required this.productId,
    required this.method,
    this.successUrl,
    this.cancelUrl,
    this.extraParams,
    this.trialPaymentMethodBehavior,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'purchase_method': method.value,
      'customer_id': customerId,
      if (trialPaymentMethodBehavior != null)
        'trial_payment_method_behavior': trialPaymentMethodBehavior!.value,
      if (successUrl != null) 'success_url': successUrl,
      if (cancelUrl != null) 'cancel_url': cancelUrl,
      if (extraParams != null) 'extra_params': extraParams,
    };
  }
}
