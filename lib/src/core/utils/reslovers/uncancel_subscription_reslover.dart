import 'package:revenipe_flutter/revenipe_flutter.dart';

CustomerSubscription resolveSubscriptionForUncancel({
  required List<CustomerSubscription> subscriptions,
  required String productId,
}) {
  if (productId.trim().isEmpty) {
    throw ArgumentError('productId is required.');
  }

  final uncancelableSubscriptions = subscriptions.where((sub) {
    final isMatchingProduct = sub.productId == productId;

    return isMatchingProduct &&
        sub.canCancel &&
        sub.willCancelAtPeriodEnd;
  }).toList();

  if (uncancelableSubscriptions.isEmpty) {
    throw StateError(
      'No uncancelable subscription found for product "$productId".',
    );
  }

  if (uncancelableSubscriptions.length > 1) {
    throw StateError(
      'Multiple uncancelable subscriptions found for product "$productId".',
    );
  }

  return uncancelableSubscriptions.first;
}