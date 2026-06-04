import 'package:flutter_test/flutter_test.dart';
import 'package:revenipe_flutter/revenipe_flutter.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - start direct trial', () async {
    requireConfigValue(directTrialProductId, 'directTrialProductId');

    final loginIdentity = loginIdentityFor('direct_trial');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final response = await startHostedCheckoutPurchase(
      revenipe,
      productId: directTrialProductId,
      trialPaymentMethodBehavior: TrialPaymentMethodBehavior.direct,
    );

    await openCheckoutIfReturned(response);
    await waitForWebhookRefresh();

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'After direct trial start',
    );

    print('\nDirect trial flow finished. Verify trialing status and paymentAttached=false above.');
  }, timeout: manualFlowTimeout);
}
