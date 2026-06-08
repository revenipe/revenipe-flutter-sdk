import 'package:flutter_test/flutter_test.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - start normal paid subscription', () async {
    requireConfigValue(normalSubscriptionProductId, 'normalSubscriptionProductId');

    final loginIdentity = loginIdentityFor('normal_subscription');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final response = await startHostedCheckoutPurchase(
      revenipe,
      productId: normalSubscriptionProductId,
    );

    await openCheckoutIfReturned(response);

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'After normal subscription Checkout',
    );

    print('\nNormal subscription flow finished. Verify the subscription and entitlements above.');
  }, timeout: manualFlowTimeout);
}
