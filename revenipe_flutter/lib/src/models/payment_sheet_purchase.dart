class PaymentSheetPurchase {
  final String customerId;
  final String customerEphemeralKeySecret;
  final String? paymentIntentClientSecret;
  final String? subscriptionId;
  final String? setupIntentClientSecret;

  const PaymentSheetPurchase({
    required this.customerId,
    required this.customerEphemeralKeySecret,
    this.paymentIntentClientSecret,
    this.subscriptionId,
    this.setupIntentClientSecret,
  });

  factory PaymentSheetPurchase.fromJson(Map<String, dynamic> json) {
    return PaymentSheetPurchase(
      customerId: json['customer_id'] as String,
      customerEphemeralKeySecret:
          json['customer_ephemeral_key_secret'] as String,
      paymentIntentClientSecret:
          json['payment_intent_client_secret'] as String?,
      subscriptionId: json['subscription_id'] as String?,
      setupIntentClientSecret:
          json['setup_intent_client_secret'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'customer_ephemeral_key_secret': customerEphemeralKeySecret,
      'payment_intent_client_secret': paymentIntentClientSecret,
      'subscription_id': subscriptionId,
      'setup_intent_client_secret': setupIntentClientSecret,
    };
  }
}