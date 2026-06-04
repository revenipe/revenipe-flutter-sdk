import 'package:flutter_test/flutter_test.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - purchase one-off product', () async {
    requireConfigValue(oneOffProductId, 'oneOffProductId');

    final loginIdentity = loginIdentityFor('one_off_purchase');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final response = await startHostedCheckoutPurchase(
      revenipe,
      productId: oneOffProductId,
    );

    await openCheckoutIfReturned(response);

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'After one-off Checkout purchase',
    );

    print('\nOne-off flow finished. Verify the entitlement/credits printed above.');
  }, timeout: manualFlowTimeout);
}
