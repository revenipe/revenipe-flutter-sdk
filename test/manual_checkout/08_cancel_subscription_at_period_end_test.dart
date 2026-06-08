import 'package:flutter_test/flutter_test.dart';
import 'package:revenipe_flutter/revenipe_flutter.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - purchase then cancel subscription at period end', () async {
    requireConfigValue(normalSubscriptionProductId, 'normalSubscriptionProductId');

    final loginIdentity = loginIdentityFor('cancel_period_end');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final purchaseResponse = await startHostedCheckoutPurchase(
      revenipe,
      productId: normalSubscriptionProductId,
    );

    await openCheckoutIfReturned(purchaseResponse);

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'Before period-end cancellation',
    );

    final cancelResponse = await revenipe.cancelSubscription(
      productId: normalSubscriptionProductId,
      cancelMode: SubscriptionCancelMode.periodEnd,
    );

    printCancelResponse(cancelResponse);
    await waitForWebhookRefresh();

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'After period-end cancellation request',
    );

    print('\nPeriod-end cancel flow finished. Verify active access plus cancelAtPeriodEnd above.');
  }, timeout: manualFlowTimeout);
}
