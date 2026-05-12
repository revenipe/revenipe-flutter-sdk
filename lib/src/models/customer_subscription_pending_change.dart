import 'package:revenipe_flutter/src/purchase/subscription_chnage_type.dart';

class CustomerSubscriptionPendingChange {
  final String changeId;
  final String type;
  final String billingMode;
  final String status;
  final String fromProductId;
  final String toProductId;
  final DateTime effectiveAt;

  const CustomerSubscriptionPendingChange({
    required this.changeId,
    required this.type,
    required this.billingMode,
    required this.status,
    required this.fromProductId,
    required this.toProductId,
    required this.effectiveAt,
  });

  SubscriptionChangeType? get changeTypeEnum {
    return SubscriptionChangeType.fromValue(type);
  }

  SubscriptionBillingMode? get billingModeEnum {
    return SubscriptionBillingMode.fromValue(billingMode);
  }

  PendingPlanChangeStatus? get statusEnum {
    return PendingPlanChangeStatus.fromValue(status);
  }

  bool get isImmediate {
    return billingMode == SubscriptionBillingMode.immediate.value;
  }

  bool get isScheduled {
    return billingMode == SubscriptionBillingMode.periodEnd.value;
  }

  factory CustomerSubscriptionPendingChange.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerSubscriptionPendingChange(
      changeId: json['change_id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      billingMode: json['billing_mode'] as String? ?? '',
      status: json['status'] as String? ?? '',
      fromProductId: json['from_product_id'] as String? ?? '',
      toProductId: json['to_product_id'] as String? ?? '',
      effectiveAt: json['effective_at'] == null
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.parse(json['effective_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'change_id': changeId,
      'type': type,
      'billing_mode': billingMode,
      'status': status,
      'from_product_id': fromProductId,
      'to_product_id': toProductId,
      'effective_at': effectiveAt.toIso8601String(),
    };
  }

  CustomerSubscriptionPendingChange copyWith({
    String? changeId,
    String? type,
    String? billingMode,
    String? status,
    String? fromProductId,
    String? toProductId,
    DateTime? effectiveAt,
  }) {
    return CustomerSubscriptionPendingChange(
      changeId: changeId ?? this.changeId,
      type: type ?? this.type,
      billingMode: billingMode ?? this.billingMode,
      status: status ?? this.status,
      fromProductId: fromProductId ?? this.fromProductId,
      toProductId: toProductId ?? this.toProductId,
      effectiveAt: effectiveAt ?? this.effectiveAt,
    );
  }
}