import 'package:revenipe_flutter/revenipe_flutter.dart';

CustomerSubscription resolveSubscriptionForPlanChange({
  required List<CustomerSubscription> subscriptions,
  String? fromProductId,
}) {
  final activeSubscriptions = subscriptions.where((sub) {
    final status = sub.status.toLowerCase();

    return status == 'active' || status == 'trialing';
  }).toList();

  if (fromProductId != null && fromProductId.isNotEmpty) {
    final matches = activeSubscriptions
        .where((sub) => sub.productId == fromProductId)
        .toList();

    if (matches.isEmpty) {
      throw StateError(
        'No active subscription found for product "$fromProductId".',
      );
    }

    if (matches.length > 1) {
      throw StateError(
        'Multiple active subscriptions found for product "$fromProductId".',
      );
    }

    return matches.first;
  }

  if (activeSubscriptions.isEmpty) {
    throw StateError('Customer has no active subscription to change.');
  }

  if (activeSubscriptions.length > 1) {
    throw StateError(
      'Customer has multiple active subscriptions. '
      'Pass fromProductId to select which subscription should be changed.',
    );
  }

  return activeSubscriptions.first;
}

CustomerSubscription resolveSubscriptionForPaymentMethodAttach({
  required List<CustomerSubscription> subscriptions,
  String? fromProductId,
}) {
  final trialingSubscriptions = subscriptions.where((sub) {
    final status = sub.status.toLowerCase();

    return status == 'trialing' && !sub.paymentMethodAttached;
  }).toList();

  if (fromProductId != null && fromProductId.isNotEmpty) {
    final matches = trialingSubscriptions
        .where((sub) => sub.productId == fromProductId)
        .toList();

    if (matches.isEmpty) {
      throw StateError(
        'No trialing subscription without a payment method was found '
        'for product "$fromProductId".',
      );
    }

    if (matches.length > 1) {
      throw StateError(
        'Multiple eligible trialing subscriptions were found for product '
        '"$fromProductId".',
      );
    }

    return matches.first;
  }

  if (trialingSubscriptions.isEmpty) {
    throw StateError(
      'Customer has no trialing subscription that requires a payment method.',
    );
  }

  if (trialingSubscriptions.length > 1) {
    throw StateError(
      'Customer has multiple trialing subscriptions that require a payment '
      'method. Pass fromProductId to select the subscription.',
    );
  }

  return trialingSubscriptions.first;
}
