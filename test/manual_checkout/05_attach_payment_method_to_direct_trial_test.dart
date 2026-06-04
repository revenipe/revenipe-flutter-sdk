import 'package:flutter_test/flutter_test.dart';
import 'package:revenipe_flutter/revenipe_flutter.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - attach payment method to direct trial', () async {
    requireConfigValue(directTrialProductId, 'directTrialProductId');

    final loginIdentity = loginIdentityFor('attach_payment_method_direct_trial10');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final trialResponse = await startHostedCheckoutPurchase(
      revenipe,
      productId: directTrialProductId,
      trialPaymentMethodBehavior: TrialPaymentMethodBehavior.direct,
    );

    await openCheckoutIfReturned(trialResponse);
    await waitForWebhookRefresh();

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'Direct trial before payment-method attachment',
    );

    print(
      '\nATTACH REQUEST uses the current session customer returned from login. '
      'The SDK resolves its internal client ID and access source.',
    );

    final attachResponse = await revenipe.attachPaymentMethodToSubscription(
      productId: directTrialProductId,
      options: const AttachPaymentMethodOptions(
        method: RevenipePurchaseMethod.hostedCheckout,
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      ),
    );

    printAttachResponse(attachResponse);
    await openAttachCheckoutIfReturned(attachResponse);
    await waitForWebhookRefresh();

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'Direct trial after payment-method attachment',
    );

    print('\nAttach payment method flow finished. Verify paymentAttached=true above.');
  }, timeout: manualFlowTimeout);
}
