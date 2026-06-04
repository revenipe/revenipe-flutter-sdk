import 'package:flutter_test/flutter_test.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - purchase normal subscription then upgrade', () async {
    requireConfigValue(normalSubscriptionProductId, 'normalSubscriptionProductId');
    requireConfigValue(upgradeSubscriptionProductId, 'upgradeSubscriptionProductId');

    final loginIdentity = loginIdentityFor('upgrade_subscription');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final purchaseResponse = await startHostedCheckoutPurchase(
      revenipe,
      productId: normalSubscriptionProductId,
    );

    await openCheckoutIfReturned(purchaseResponse);

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'Before upgrade',
    );

    final upgradeResponse = await revenipe.changeSubscription(
      fromProductId: normalSubscriptionProductId,
      newProductId: upgradeSubscriptionProductId,
    );

    printChangeResponse(upgradeResponse);
    await waitForWebhookRefresh();

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'After upgrade request/webhook wait',
    );

    print('\nUpgrade flow finished. Verify upgraded product and entitlements above.');
  }, timeout: manualFlowTimeout);
}
