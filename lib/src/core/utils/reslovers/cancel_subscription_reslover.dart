import 'package:revenipe_flutter/revenipe_flutter.dart';

CustomerSubscription resolveSubscriptionForCancel({
  required List<CustomerSubscription> subscriptions,
  String? productId,
}) {
  final cancelableSubscriptions = subscriptions.where((sub) {
    final status = sub.status.toLowerCase();

    final isActive = status == 'active' || status == 'trialing';

    return isActive && sub.canCancel && !sub.willCancelAtPeriodEnd;
  }).toList();

  if (productId != null && productId.isNotEmpty) {
    final matches = cancelableSubscriptions
        .where((sub) => sub.productId == productId)
        .toList();

    if (matches.isEmpty) {
      throw StateError(
        'No cancelable active subscription found for product "$productId".',
      );
    }

    if (matches.length > 1) {
      throw StateError(
        'Multiple cancelable subscriptions found for product "$productId".',
      );
    }

    return matches.first;
  }

  if (cancelableSubscriptions.isEmpty) {
    throw StateError('Customer has no cancelable active subscription.');
  }

  if (cancelableSubscriptions.length > 1) {
    throw StateError(
      'Customer has multiple cancelable subscriptions. '
      'Pass productId to select which subscription should be canceled.',
    );
  }

  return cancelableSubscriptions.first;
}
