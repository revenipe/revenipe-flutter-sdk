import 'package:revenipe_flutter/src/models/base_plan.dart';
import 'package:revenipe_flutter/src/models/models.dart';

class RefreshClientEntitlementsResponse {
  final List<CustomerEntitlement> entitlements;
  final List<UsageKey> usageKeys;
  final List<CustomerSubscription> subscriptions;
  final List<CustomerAddOn> addOns;
  final List<CustomerBasePlan> basePlans;

  const RefreshClientEntitlementsResponse({
    required this.entitlements,
    required this.usageKeys,
    required this.subscriptions,
    required this.addOns,
    required this.basePlans,
  });

  factory RefreshClientEntitlementsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return RefreshClientEntitlementsResponse(
      entitlements: (json['entitlements'] as List<dynamic>? ?? [])
          .map((e) => CustomerEntitlement.fromJson(e as Map<String, dynamic>))
          .toList(),
      usageKeys: (json['usage_keys'] as List<dynamic>? ?? [])
          .map((e) => UsageKey.fromJson(e as Map<String, dynamic>))
          .toList(),
      subscriptions: (json['subscriptions'] as List<dynamic>? ?? [])
          .map((e) => CustomerSubscription.fromJson(e as Map<String, dynamic>))
          .toList(),
      addOns: (json['add_ons'] as List<dynamic>? ?? [])
          .map((e) => CustomerAddOn.fromJson(e as Map<String, dynamic>))
          .toList(),
      basePlans: (json['base_plans'] as List<dynamic>? ?? [])
          .map((e) => CustomerBasePlan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}