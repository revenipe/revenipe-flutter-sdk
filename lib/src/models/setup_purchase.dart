class SetupPurchase {
  final String customerId;
  final String ephemeralKey;
  final String setupIntentId;
  final String setupIntentClientSecret;

  const SetupPurchase({
    required this.customerId,
    required this.ephemeralKey,
    required this.setupIntentId,
    required this.setupIntentClientSecret,
  });

  factory SetupPurchase.fromJson(Map<String, dynamic> json) {
    return SetupPurchase(
      customerId: json['customer_id'] as String,
      ephemeralKey: json['ephemeral_key'] as String,
      setupIntentId: json['setup_intent_id'] as String,
      setupIntentClientSecret: json['setup_intent_client_secret'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'ephemeral_key': ephemeralKey,
      'setup_intent_id': setupIntentId,
      'setup_intent_client_secret': setupIntentClientSecret,
    };
  }

  SetupPurchase copyWith({
    String? customerId,
    String? ephemeralKey,
    String? setupIntentId,
    String? setupIntentClientSecret,
  }) {
    return SetupPurchase(
      customerId: customerId ?? this.customerId,
      ephemeralKey: ephemeralKey ?? this.ephemeralKey,
      setupIntentId: setupIntentId ?? this.setupIntentId,
      setupIntentClientSecret:
          setupIntentClientSecret ?? this.setupIntentClientSecret,
    );
  }
}
