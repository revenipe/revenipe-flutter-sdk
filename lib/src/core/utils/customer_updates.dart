import 'package:revenipe_flutter/revenipe_flutter.dart';

extension RevenipeCustomerUpdates on RevenipeCustomer {
  RevenipeCustomer updateEntitlement(CustomerEntitlement updatedEntitlement) {
    final updatedEntitlements = entitlements.map((entitlement) {
      if (entitlement.entitlementId == updatedEntitlement.entitlementId) {
        return updatedEntitlement;
      }
      return entitlement;
    }).toList();

    return copyWith(entitlements: updatedEntitlements);
  }

  RevenipeCustomer updateEntitlements(List<CustomerEntitlement> updatedItems) {
    final map = {
      for (final entitlement in entitlements)
        entitlement.entitlementId: entitlement,
    };

    for (final item in updatedItems) {
      map[item.entitlementId] = item;
    }

    return copyWith(entitlements: map.values.toList());
  }
}

extension RevenipeCustomerEntitlementValueUpdate on RevenipeCustomer {
  RevenipeCustomer updateEntitlementRemaining({
    required String entitlementId,
    required int newRemaining,
  }) {
    final updatedEntitlements = entitlements.map((e) {
      if (e.entitlementId == entitlementId) {
        return e.copyWith(remaining: newRemaining);
      }
      return e;
    }).toList();

    return copyWith(entitlements: updatedEntitlements);
  }

  RevenipeCustomer decreaseEntitlementRemaining({
    required String entitlementId,
    required int amount,
  }) {
    final updatedEntitlements = entitlements.map((e) {
      if (e.entitlementId == entitlementId) {
        final updated = e.remaining - amount;
        return e.copyWith(remaining: updated < 0 ? 0 : updated);
      }
      return e;
    }).toList();

    return copyWith(entitlements: updatedEntitlements);
  }
}

extension RevenipeCustomerUsageKeyUpdate on RevenipeCustomer {
  RevenipeCustomer updateUsageKeyRemaining({
    required String usageKeyId,
    required int newRemaining,
  }) {
    final updatedUsageKeys = usageKeys.map((key) {
      if (key.usageKeyId == usageKeyId) {
        return key.copyWith(remaining: newRemaining);
      }
      return key;
    }).toList();

    return copyWith(usageKeys: updatedUsageKeys);
  }
}
