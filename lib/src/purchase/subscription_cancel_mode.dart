enum SubscriptionCancelMode {
  periodEnd('period_end'),
  immediately('immediately');

  final String value;

  const SubscriptionCancelMode(this.value);

  static SubscriptionCancelMode? fromValue(String? value) {
    if (value == null) return null;

    for (final mode in SubscriptionCancelMode.values) {
      if (mode.value == value) return mode;
    }

    return null;
  }
}