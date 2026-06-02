import 'package:revenipe_flutter/revenipe_flutter.dart';
import 'package:revenipe_flutter/src/core/utils/customer_updates.dart';

extension RevenipeSessionValueUpdate on RevenipeSession {
  RevenipeSession updateEntitlementRemaining({
    required String entitlementId,
    required int newRemaining,
  }) {
    final updatedCustomer = customer.updateEntitlementRemaining(
      entitlementId: entitlementId,
      newRemaining: newRemaining,
    );

    return copyWith(customer: updatedCustomer);
  }

  RevenipeSession decreaseEntitlementRemaining({
    required String entitlementId,
    required int amount,
  }) {
    final updatedCustomer = customer.decreaseEntitlementRemaining(
      entitlementId: entitlementId,
      amount: amount,
    );

    return copyWith(customer: updatedCustomer);
  }
}

extension RevenipeSessionUsageKeyUpdate on RevenipeSession {
  RevenipeSession updateUsageKeyRemaining({
    required String usageKeyId,
    required int newRemaining,
  }) {
    final updatedCustomer = customer.updateUsageKeyRemaining(
      usageKeyId: usageKeyId,
      newRemaining: newRemaining,
    );

    return copyWith(customer: updatedCustomer);
  }
}
