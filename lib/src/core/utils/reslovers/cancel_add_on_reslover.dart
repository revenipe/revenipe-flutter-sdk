import 'package:revenipe_flutter/revenipe_flutter.dart';

CustomerAddOn resolveAddOnForCancel({
  required List<CustomerAddOn> addOns,
  String? productId,
}) {
  final cancelableAddOns = addOns.where((addOn) {
    final status = addOn.status.toLowerCase();

    return status == 'active' && addOn.canCancel;
  }).toList();

  if (productId != null && productId.isNotEmpty) {
    final matches = cancelableAddOns
        .where((addOn) => addOn.productId == productId)
        .toList();

    if (matches.isEmpty) {
      throw StateError(
        'No cancelable active add-on found for product "$productId".',
      );
    }

    if (matches.length > 1) {
      throw StateError(
        'Multiple cancelable active add-ons found for product "$productId".',
      );
    }

    return matches.first;
  }

  if (cancelableAddOns.isEmpty) {
    throw StateError('Customer has no cancelable active add-on.');
  }

  if (cancelableAddOns.length > 1) {
    throw StateError(
      'Customer has multiple cancelable active add-ons. '
      'Pass productId to select which add-on should be canceled.',
    );
  }

  return cancelableAddOns.first;
}
