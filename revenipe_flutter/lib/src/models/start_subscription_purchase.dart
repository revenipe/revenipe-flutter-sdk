class StartSubscriptionPurchase {
  final String subscriptionId;
  final String status;
  final DateTime? trialEnd;

  const StartSubscriptionPurchase({
    required this.subscriptionId,
    required this.status,
    this.trialEnd,
  });

  factory StartSubscriptionPurchase.fromJson(Map<String, dynamic> json) {
    return StartSubscriptionPurchase(
      subscriptionId: json['subscription_id'] as String,
      status: json['status'] as String,
      trialEnd: json['trial_end'] == null
          ? null
          : DateTime.parse(json['trial_end'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription_id': subscriptionId,
      'status': status,
      if (trialEnd != null) 'trial_end': trialEnd!.toIso8601String(),
    };
  }

  StartSubscriptionPurchase copyWith({
    String? subscriptionId,
    String? status,
    DateTime? trialEnd,
  }) {
    return StartSubscriptionPurchase(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      status: status ?? this.status,
      trialEnd: trialEnd ?? this.trialEnd,
    );
  }
}