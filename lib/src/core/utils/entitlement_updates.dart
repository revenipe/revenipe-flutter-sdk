import 'package:revenipe_flutter/revenipe_flutter.dart';

extension CustomerEntitlementValueUpdate on CustomerEntitlement {
  CustomerEntitlement updateRemaining(int newRemaining) {
    return copyWith(remaining: newRemaining);
  }

  CustomerEntitlement decreaseRemaining(int amount) {
    final updated = remaining - amount;
    return copyWith(remaining: updated < 0 ? 0 : updated);
  }

  CustomerEntitlement increaseRemaining(int amount) {
    return copyWith(remaining: remaining + amount);
  }
}
