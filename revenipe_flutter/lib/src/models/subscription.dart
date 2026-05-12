import 'package:revenipe_flutter/src/models/customer_subscription_pending_change.dart';

class CustomerSubscription {
  final String accessSourceId;
  final String productId;
  final String productName;
  final String status;
  final String provider;
  final bool isTrial;
  final DateTime? renewsAt;
  final DateTime? expiresAt;
  final bool willCancelAtPeriodEnd;
  final bool canCancel;
  final CustomerSubscriptionPendingChange? pendingChange;

  const CustomerSubscription({
    required this.accessSourceId,
    required this.productId,
    required this.productName,
    required this.status,
    required this.provider,
    required this.isTrial,
    required this.renewsAt,
    required this.expiresAt,
    required this.willCancelAtPeriodEnd,
    required this.canCancel,
    this.pendingChange,
  });

  factory CustomerSubscription.fromJson(Map<String, dynamic> json) {
    return CustomerSubscription(
      accessSourceId: json['access_source_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      isTrial: json['is_trial'] as bool? ?? false,
      renewsAt: json['renews_at'] != null
          ? DateTime.tryParse(json['renews_at'] as String)
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null,
      willCancelAtPeriodEnd:
          json['will_cancel_at_period_end'] as bool? ?? false,
      canCancel: json['can_cancel'] as bool? ?? false,
      pendingChange: json['pending_change'] == null
          ? null
          : CustomerSubscriptionPendingChange.fromJson(
              json['pending_change'] as Map<String, dynamic>,
            ),
    );
  }

  CustomerSubscription copyWith({
    String? accessSourceId,
    String? productId,
    String? productName,
    String? status,
    String? provider,
    bool? isTrial,
    DateTime? renewsAt,
    DateTime? expiresAt,
    bool? willCancelAtPeriodEnd,
    bool? canCancel,
    CustomerSubscriptionPendingChange? pendingChange,
    bool clearPendingChange = false,
  }) {
    return CustomerSubscription(
      accessSourceId: accessSourceId ?? this.accessSourceId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      isTrial: isTrial ?? this.isTrial,
      renewsAt: renewsAt ?? this.renewsAt,
      expiresAt: expiresAt ?? this.expiresAt,
      willCancelAtPeriodEnd:
          willCancelAtPeriodEnd ?? this.willCancelAtPeriodEnd,
      canCancel: canCancel ?? this.canCancel,
      pendingChange: clearPendingChange
          ? null
          : pendingChange ?? this.pendingChange,
    );
  }
}
