import 'package:flutter_test/flutter_test.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - purchase access then track entitlement usage', () async {
    requireConfigValue(trackingAccessProductId, 'trackingAccessProductId');
    requireConfigValue(
      trackingEntitlementOrUsageKeyId,
      'trackingEntitlementOrUsageKeyId',
    );

    final loginIdentity = loginIdentityFor('normal_subscription');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

   /* final purchaseResponse = await startHostedCheckoutPurchase(
      revenipe,
      productId: trackingAccessProductId,
    );*/

   // await openCheckoutIfReturned(purchaseResponse);

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'Before tracking usage',
    );

    print(
      '\nTRACK USAGE: id=$trackingEntitlementOrUsageKeyId, amount=$trackingAmount',
    );

    final trackingResponse = await revenipe.track(
      trackingEntitlementOrUsageKeyId,
      trackingAmount,
    );

    print('success: ${trackingResponse.success}');
    print('requested: ${trackingResponse.requested}');
    print('consumed: ${trackingResponse.consumed}');
    print('remaining: ${trackingResponse.remaining}');
    print('entitlementId: ${trackingResponse.entitlementId}');
    print('accessSourceId: ${trackingResponse.accessSourceId}');
    print('error: ${trackingResponse.error}');

    await refreshByExternalIdentity(
      revenipe,
      loginIdentity,
      label: 'After tracking usage',
    );

    print('\nTracking flow finished. Verify remaining value above.');
  }, timeout: manualFlowTimeout);
}
