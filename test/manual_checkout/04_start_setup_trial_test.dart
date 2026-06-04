import 'package:flutter_test/flutter_test.dart';
import 'package:revenipe_flutter/revenipe_flutter.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - start setup-intent trial', () async {
    requireConfigValue(setupTrialProductId, 'setupTrialProductId');

    final loginIdentity = loginIdentityFor('setup_trial');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final response = await startHostedCheckoutPurchase(
      revenipe,
      productId: setupTrialProductId,
      trialPaymentMethodBehavior: TrialPaymentMethodBehavior.setupIntent,
    );

    await openCheckoutIfReturned(response);
    await waitForWebhookRefresh();

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'After setup-intent trial flow',
    );

    print(
      '\nSetup trial flow finished. If the response printed setup/paymentSheet data '
      'but no Checkout URL, this specific path needs a real Flutter PaymentSheet screen.',
    );
  }, timeout: manualFlowTimeout);
}
