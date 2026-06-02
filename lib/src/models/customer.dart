import 'package:revenipe_flutter/revenipe_flutter.dart';
import 'package:revenipe_flutter/src/models/base_plan.dart';

class RevenipeCustomer {
  final List<CustomerEntitlement> entitlements;
  final List<UsageKey> usageKeys;
  final List<CustomerSubscription> subscriptions;
  final List<CustomerAddOn> addOns;
  final List<CustomerBasePlan> basePlans;
  final String customerId;

  const RevenipeCustomer({
    required this.entitlements,
    required this.usageKeys,
    required this.subscriptions,
    required this.addOns,
    required this.customerId,
    required this.basePlans,
  });

  factory RevenipeCustomer.fromJson(Map<String, dynamic> json) {
    return RevenipeCustomer(
      customerId: json['client_id'] as String,
      basePlans: (json['base_plans'] as List<dynamic>? ?? [])
          .map(
            (item) => CustomerBasePlan.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      entitlements: (json['entitlements'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                CustomerEntitlement.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      usageKeys: (json['usage_keys'] as List<dynamic>? ?? [])
          .map((item) => UsageKey.fromJson(item as Map<String, dynamic>))
          .toList(),
      subscriptions: (json['subscriptions'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                CustomerSubscription.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      addOns: (json['add_ons'] as List<dynamic>? ?? [])
          .map((item) => CustomerAddOn.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  RevenipeCustomer copyWith({
    List<CustomerEntitlement>? entitlements,
    List<UsageKey>? usageKeys,
    List<CustomerSubscription>? subscriptions,
    List<CustomerAddOn>? addOns,
    String? customerId,
    List<CustomerBasePlan>? basePlans,
  }) {
    return RevenipeCustomer(
      basePlans: basePlans ?? this.basePlans,
      entitlements: entitlements ?? this.entitlements,
      usageKeys: usageKeys ?? this.usageKeys,
      subscriptions: subscriptions ?? this.subscriptions,
      addOns: addOns ?? this.addOns,
      customerId: customerId ?? this.customerId,
    );
  }

  CustomerBasePlan? get currentBasePlan {
    if (basePlans.isEmpty) {
      return null;
    }

    return basePlans.first;
  }

  bool get hasBasePlan => currentBasePlan != null;

  bool get hasActiveSubscription {
    return subscriptions.any((subscription) {
      final status = subscription.status.toLowerCase();
      return status == 'active' || status == 'trialing';
    });
  }
}
