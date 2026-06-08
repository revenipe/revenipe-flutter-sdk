import 'package:flutter_test/flutter_test.dart';
import 'package:revenipe_flutter/revenipe_flutter.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - purchase then cancel subscription immediately', () async {
    requireConfigValue(normalSubscriptionProductId, 'normalSubscriptionProductId');

    final loginIdentity = loginIdentityFor('cancel_immediately');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final purchaseResponse = await startHostedCheckoutPurchase(
      revenipe,
      productId: normalSubscriptionProductId,
    );

    await openCheckoutIfReturned(purchaseResponse);

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'Before immediate cancellation',
    );

    final cancelResponse = await revenipe.cancelSubscription(
      productId: normalSubscriptionProductId,
      cancelMode: SubscriptionCancelMode.immediately,
    );

    printCancelResponse(cancelResponse);
    await waitForWebhookRefresh();

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'After immediate cancellation',
    );

    print('\nImmediate cancel flow finished. Verify access/subscription status above.');
  }, timeout: manualFlowTimeout);
}
