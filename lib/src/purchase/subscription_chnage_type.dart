enum SubscriptionChangeType {
  upgrade('upgrade'),
  downgrade('downgrade'),
  intervalUpgrade('interval_upgrade'),
  intervalDowngrade('interval_downgrade'),
  samePriceSwitch('same_price_switch');

  final String value;

  const SubscriptionChangeType(this.value);

  static SubscriptionChangeType? fromValue(String? value) {
    if (value == null) return null;

    for (final item in SubscriptionChangeType.values) {
      if (item.value == value) return item;
    }

    return null;
  }
}

enum SubscriptionBillingMode {
  immediate('immediate'),
  periodEnd('period_end');

  final String value;

  const SubscriptionBillingMode(this.value);

  static SubscriptionBillingMode? fromValue(String? value) {
    if (value == null) return null;

    for (final item in SubscriptionBillingMode.values) {
      if (item.value == value) return item;
    }

    return null;
  }
}

enum PendingPlanChangeStatus {
  pending('pending'),
  billingApplied('billing_applied'),
  accessApplied('access_applied'),
  failed('failed'),
  canceled('canceled');

  final String value;

  const PendingPlanChangeStatus(this.value);

  static PendingPlanChangeStatus? fromValue(String? value) {
    if (value == null) return null;

    for (final item in PendingPlanChangeStatus.values) {
      if (item.value == value) return item;
    }

    return null;
  }
}
