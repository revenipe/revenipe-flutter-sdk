import 'package:revenipe_flutter/src/purchase/subscription_chnage_type.dart';

class ChangeSubscriptionPlanResponse {
  final bool success;
  final String changeType;
  final String billingMode;
  final String status;
  final DateTime effectiveAt;
  final String? message;

  const ChangeSubscriptionPlanResponse({
    required this.success,
    required this.changeType,
    required this.billingMode,
    required this.status,
    required this.effectiveAt,
    this.message,
  });

  SubscriptionChangeType? get changeTypeEnum {
    return SubscriptionChangeType.fromValue(changeType);
  }

  SubscriptionBillingMode? get billingModeEnum {
    return SubscriptionBillingMode.fromValue(billingMode);
  }

  bool get isImmediate {
    return billingMode == SubscriptionBillingMode.immediate.value;
  }

  bool get isScheduled {
    return billingMode == SubscriptionBillingMode.periodEnd.value;
  }

  factory ChangeSubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    return ChangeSubscriptionPlanResponse(
      success: json['success'] as bool? ?? false,
      changeType: json['change_type'] as String? ?? '',
      billingMode: json['billing_mode'] as String? ?? '',
      status: json['status'] as String? ?? '',
      effectiveAt: json['effective_at'] == null
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.parse(json['effective_at'] as String),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'change_type': changeType,
      'billing_mode': billingMode,
      'status': status,
      'effective_at': effectiveAt.toIso8601String(),
      if (message != null) 'message': message,
    };
  }
}
