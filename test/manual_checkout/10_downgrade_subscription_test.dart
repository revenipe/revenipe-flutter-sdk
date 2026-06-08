import 'package:flutter_test/flutter_test.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - purchase upgraded subscription then downgrade', () async {
    requireConfigValue(normalSubscriptionProductId, 'normalSubscriptionProductId');
    requireConfigValue(upgradeSubscriptionProductId, 'upgradeSubscriptionProductId');

    final loginIdentity = loginIdentityFor('downgrade_subscription');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final purchaseResponse = await startHostedCheckoutPurchase(
      revenipe,
      productId: upgradeSubscriptionProductId,
    );

    await openCheckoutIfReturned(purchaseResponse);

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'Before downgrade',
    );

    final downgradeResponse = await revenipe.changeSubscription(
      fromProductId: upgradeSubscriptionProductId,
      newProductId: normalSubscriptionProductId,
    );

    printChangeResponse(downgradeResponse);
    await waitForWebhookRefresh();

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'After downgrade request',
    );

    print('\nDowngrade flow finished. Verify pending plan change above.');
  }, timeout: manualFlowTimeout);
}
