class UncancelSubscriptionResponse {
  const UncancelSubscriptionResponse({
    required this.success,
  });

  final bool success;

  factory UncancelSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return UncancelSubscriptionResponse(
      success: json['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
    };
  }
}