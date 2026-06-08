class CancelSubscriptionResponse {
  final bool success;
  final String status;
  final bool willCancelAtPeriodEnd;
  final DateTime? cancelsAt;
  final String? message;

  const CancelSubscriptionResponse({
    required this.success,
    required this.status,
    required this.willCancelAtPeriodEnd,
    this.cancelsAt,
    this.message,
  });

  factory CancelSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return CancelSubscriptionResponse(
      success: json['success'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      willCancelAtPeriodEnd:
          json['will_cancel_at_period_end'] as bool? ?? false,
      cancelsAt: json['cancels_at'] == null
          ? null
          : DateTime.tryParse(json['cancels_at'] as String),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'will_cancel_at_period_end': willCancelAtPeriodEnd,
      if (cancelsAt != null) 'cancels_at': cancelsAt!.toIso8601String(),
      if (message != null) 'message': message,
    };
  }
}
