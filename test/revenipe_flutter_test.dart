import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:revenipe_flutter/revenipe_flutter.dart';

// -----------------------------------------------------------------------------
// Revenipe manual Checkout integration test placeholders
// -----------------------------------------------------------------------------
// Fill these values before running the manual test flow.
// Keep real secrets out of git.

const baseUrl = 'https://staging.revenipe.com/';
const appKey = 'app_sandbox_6a18a8b24c6877c0d4a784975fdf257b51c768d246e22f1979160bc6ed821c92348a81c2';
const customerId = 'payment_flow_test_customer';

// Subscription products:
//
// basicProductId / proProductId:
// Used for active paid subscription purchase, upgrade, downgrade, and immediate
// cancel testing.
//
// directTrialProductId:
// Separate recurring product configured for direct trial testing.
//
// setupIntentTrialProductId:
// Separate recurring product configured for setup-intent trial testing.
//
// Important:
// Do not reuse the same product ID for all subscription flows with the same
// customer. Revenipe allows only one active/trialing subscription per product
// context, so the trial tests need separate product IDs.
const basicProductId = 'basic_club';
const proProductId = 'pro_club';
const directTrialProductId = 'trial_direct';
const setupIntentTrialProductId = 'trial_setup';

// One-off product:
//
// This is a normal one-off product purchase, not an add-on.
const oneOffProductId = '250_credits_pack';

// Add-on products:
//
// oneOffAddOnProductId:
// Separate one-off add-on product.
//
// recurringAddOnProductId:
// Separate recurring add-on product.
const oneOffAddOnProductId = '50_image_exports_add_on';
const recurringAddOnProductId = '100_image_exports_add_on';

const usageKeyOrEntitlementId = 'image_export';

const successUrl = 'https://revenipe.test/success';
const cancelUrl = 'https://revenipe.test/canceled';

const webhookWaitSeconds = 45;
const openCheckoutInBrowser = true;

void main() {
  final revenipe = Revenipe.instance;

  setUpAll(() async {
    await setupRevenipe(revenipe);

    if (_hasRequiredSetupPlaceholders) {
      await loginTestCustomer(revenipe);
      await fetchAndPrintProducts(revenipe);
    } else {
      _printSkip(
        'setUpAll login/products',
        'Fill baseUrl, appKey, and customerId first.',
      );
    }
  });

  group('1. SDK setup', () {
    test('configures SDK, logs in customer, fetches products', () async {
      if (!_hasRequiredSetupPlaceholders) {
        _printSkip(
          'SDK setup',
          'Fill baseUrl, appKey, and customerId first.',
        );
        return;
      }

      expect(revenipe.isInitialized, isTrue);
      expect(revenipe.isIdentified, isTrue);
      

      await fetchAndPrintProducts(revenipe);

      await refreshCustomerAndPrintState(
        revenipe,
        label: 'Initial customer',
      );
    });
  });

  group('Check BasePlan', () {
    test('purchases Basic subscription product through Checkout', () async {

      if(revenipe.customer!.hasBasePlan)
      {
        print('Plan Name: ${revenipe.customer!.currentBasePlan!.productName}');
        print('Period End: ${revenipe.customer!.currentBasePlan!.periodEnd}');
        print('Interval: ${revenipe.customer!.currentBasePlan!.interval}');
      }
      else
      {
        print("customer has no base plan");
      }
    });
  });

  

 /* group('2. Checkout subscription purchase', () {
    test('purchases Basic subscription product through Checkout', () async {
      if (!_canRunProductFlow(basicProductId, 'basicProductId')) return;

      final response = await startCheckoutPurchase(
        revenipe,
        productId: basicProductId,
      );

      printPurchaseResponse(response);

      await handleCheckoutIfPresent(revenipe, response);

      final customer = await refreshCustomerAndPrintState(
        revenipe,
        label: 'After Basic subscription Checkout purchase',
      );

      final hasBasic = revenipe.hasSubscription(basicProductId);
      print('hasSubscription($basicProductId): $hasBasic');

      if (customer.subscriptions.isNotEmpty) {
        expect(customer.subscriptions.length, greaterThanOrEqualTo(1));
      }
    });
  });*/

  

 /* group('3. Direct trial subscription', () {
    test('starts direct trial with separate trial product ID', () async {
      if (!_canRunProductFlow(
        directTrialProductId,
        'directTrialProductId',
      )) {
        return;
      }

      final response = await startCheckoutPurchase(
        revenipe,
        productId: directTrialProductId,
        trialPaymentMethodBehavior: TrialPaymentMethodBehavior.direct,
      );

      printPurchaseResponse(response);

      if (response.checkout == null) {
        print(
          'Direct trial returned no Checkout URL. That is expected when the '
          'backend creates a trial subscription directly.',
        );
      }

      await handleCheckoutIfPresent(revenipe, response);
      await waitForWebhookProcessing();

      final customer = await refreshCustomerAndPrintState(
        revenipe,
        label: 'After direct trial start',
      );

      final trialSubscription = _findSubscription(
        customer,
        directTrialProductId,
      );

      print('Direct-trial subscription status: ${trialSubscription?.status}');
      print('Direct-trial isTrial: ${trialSubscription?.isTrial}');

      if (!_isEmpty(proProductId)) {
        await expectTrialPlanChangeBlocked(
          revenipe,
          customer: customer,
          fromProductId: directTrialProductId,
          targetProductId: proProductId,
        );
      } else {
        _printSkip(
          'direct trial plan-change block check',
          'Fill proProductId.',
        );
      }
    });
  });*/

  /*group('4. SetupIntent trial subscription', () {
    test('starts setup-intent trial with separate trial product ID', () async {
      if (!_canRunProductFlow(
        setupIntentTrialProductId,
        'setupIntentTrialProductId',
      )) {
        return;
      }

      final response = await startCheckoutPurchase(
        revenipe,
        productId: setupIntentTrialProductId,
        trialPaymentMethodBehavior: TrialPaymentMethodBehavior.setupIntent,
      );

      printPurchaseResponse(response);

      if (response.checkout == null && response.setup != null) {
        print(
          'SetupIntent trial returned setup data but no Checkout URL. Current SDK '
          'model exposes setupIntentClientSecret, not a hosted setup URL.',
        );
      }

      await handleCheckoutIfPresent(revenipe, response);
      await waitForWebhookProcessing();

      final customer = await refreshCustomerAndPrintState(
        revenipe,
        label: 'After setup-intent trial start',
      );

      final trialSubscription = _findSubscription(
        customer,
        setupIntentTrialProductId,
      );

      print('SetupIntent-trial subscription status: ${trialSubscription?.status}');
      print('SetupIntent-trial isTrial: ${trialSubscription?.isTrial}');

      if (!_isEmpty(proProductId)) {
        await expectTrialPlanChangeBlocked(
          revenipe,
          customer: customer,
          fromProductId: setupIntentTrialProductId,
          targetProductId: proProductId,
        );
      } else {
        _printSkip(
          'setup-intent trial plan-change block check',
          'Fill proProductId.',
        );
      }
    });
  });*/

 /* group('5. Active subscription plan change', () {
    test('upgrades Basic to Pro, then schedules/downgrades Pro to Basic', () async {
      if (!_canRunProductFlow(basicProductId, 'basicProductId')) return;
      if (!_canRunProductFlow(proProductId, 'proProductId')) return;

      var customer = await refreshCustomerAndPrintState(
        revenipe,
        label: 'Before upgrade',
      );

      print('Starting subscription upgrade: $basicProductId -> $proProductId');

      final upgradeResponse = await revenipe.changeSubscription(
        customer: customer,
        fromProductId: basicProductId,
        newProductId: proProductId,
      );

      printChangeSubscriptionResponse(upgradeResponse);

      await waitForWebhookProcessing();

      customer = await refreshCustomerAndPrintState(
        revenipe,
        label: 'After upgrade webhook wait',
      );

      print(
        'hasSubscription($proProductId): '
        '${revenipe.hasSubscription(proProductId)}',
      );

      print('Starting subscription downgrade: $proProductId -> $basicProductId');

      final downgradeResponse = await revenipe.changeSubscription(
        customer: customer,
        fromProductId: proProductId,
        newProductId: basicProductId,
      );

      printChangeSubscriptionResponse(downgradeResponse);

      print(
        'Downgrade scheduled: ${downgradeResponse.isScheduled}. '
        'Immediate: ${downgradeResponse.isImmediate}',
      );

      await refreshCustomerAndPrintState(
        revenipe,
        label: 'After downgrade request',
      );
    });
  });*/

 /* group('6. Subscription cancel', () {
    test('cancels active Basic subscription immediately', () async {
      if (!_canRunProductFlow(basicProductId, 'basicProductId')) return;

      final customer = await refreshCustomerAndPrintState(
        revenipe,
        label: 'Before immediate subscription cancel',
      );

      final response = await revenipe.cancelSubscription(
        customer: customer,
        productId: basicProductId,
        cancelMode: SubscriptionCancelMode.immediately,
      );

      print('Cancel subscription response:');
      print('  success: ${response.success}');
      print('  status: ${response.status}');
      print('  willCancelAtPeriodEnd: ${response.willCancelAtPeriodEnd}');
      print('  cancelsAt: ${response.cancelsAt}');
      print('  message: ${response.message}');
      print(
        'Immediate cancel should revoke/end the subscription through the backend '
        'and Stripe flow. Refresh after webhook processing to confirm source state.',
      );

      await waitForWebhookProcessing();

      await refreshCustomerAndPrintState(
        revenipe,
        label: 'After immediate subscription cancel',
      );
    });
  });*/

  /*group('7. Checkout one-off product purchase', () {
    test('purchases one-off product through Checkout', () async {
      if (!_canRunProductFlow(oneOffProductId, 'oneOffProductId')) return;

      final response = await startCheckoutPurchase(
        revenipe,
        productId: oneOffProductId,
      );

      printPurchaseResponse(response);

      await handleCheckoutIfPresent(revenipe, response);

      await refreshCustomerAndPrintState(
        revenipe,
        label: 'After one-off product Checkout purchase',
      );
    });
  });*/

  

 /* group('8. Checkout one-off add-on purchase', () {
    test('purchases one-off add-on through Checkout', () async {
      if (!_canRunProductFlow(oneOffAddOnProductId, 'oneOffAddOnProductId')) {
        return;
      }

      final response = await startCheckoutPurchase(
        revenipe,
        productId: oneOffAddOnProductId,
      );

      printPurchaseResponse(response);

      await handleCheckoutIfPresent(revenipe, response);

      final customer = await refreshCustomerAndPrintState(
        revenipe,
        label: 'After one-off add-on Checkout purchase',
      );

      final matchingAddOns = customer.addOns.where(
        (item) => item.productId == oneOffAddOnProductId,
      );

      final addOn = matchingAddOns.isEmpty ? null : matchingAddOns.first;

      print('One-off add-on status: ${addOn?.status}');
      print('One-off add-on billingType: ${addOn?.billingType}');
    });
  });*/



  /*group('9. Checkout recurring add-on purchase', () {
    test('purchases recurring add-on through Checkout', () async {
      if (!_canRunProductFlow(
        recurringAddOnProductId,
        'recurringAddOnProductId',
      )) {
        return;
      }

      final response = await startCheckoutPurchase(
        revenipe,
        productId: recurringAddOnProductId,
      );

      printPurchaseResponse(response);

      print(
        'Recurring add-on must not be treated as active immediately. '
        'Wait for invoice.paid webhook, then refresh customer.',
      );

      if (response.checkout == null) {
        print(
          'No Checkout URL returned. If backend returns a pending payment style '
          'response for recurring add-ons, do not treat the add-on as active until '
          'the webhook updates the customer state.',
        );
      }

      await handleCheckoutIfPresent(revenipe, response);
      await waitForWebhookProcessing();

      final customer = await refreshCustomerAndPrintState(
        revenipe,
        label: 'After recurring add-on Checkout purchase',
      );

      final matchingAddOns = customer.addOns.where(
        (item) => item.productId == recurringAddOnProductId,
      );

      final addOn = matchingAddOns.isEmpty ? null : matchingAddOns.first;

      print('Recurring add-on status: ${addOn?.status}');
      print('Recurring add-on billingType: ${addOn?.billingType}');
    });
  });*/

  

  /*group('10. Entitlement checks and usage tracking', () {
    test('checks entitlement/subscription helpers and tracks usage', () async {
      if (!_hasRequiredSetupPlaceholders) {
        _printSkip(
          'entitlement checks',
          'Fill baseUrl, appKey, and customerId.',
        );
        return;
      }

      if (_isEmpty(usageKeyOrEntitlementId)) {
        _printSkip(
          'usage tracking',
          'Fill usageKeyOrEntitlementId with either a usage key ID or entitlement ID.',
        );
        return;
      }

      await refreshCustomerAndPrintState(
        revenipe,
        label: 'Before usage tracking',
      );

      print(
        'hasEntitlement($usageKeyOrEntitlementId): '
        '${revenipe.hasEntitlement(usageKeyOrEntitlementId)}',
      );

      print(
        'getEntitlement($usageKeyOrEntitlementId): '
        '${formatEntitlement(revenipe.getEntitlement(usageKeyOrEntitlementId))}',
      );

      print(
        'getUsageKey($usageKeyOrEntitlementId): '
        '${formatUsageKey(revenipe.getUsageKey(usageKeyOrEntitlementId))}',
      );

      final result = await revenipe.track(usageKeyOrEntitlementId, 93);

      print('Track response:');
      print('  success: ${result.success}');
      print('  requested: ${result.requested}');
      print('  consumed: ${result.consumed}');
      print('  remaining: ${result.remaining}');
      print('  entitlementId: ${result.entitlementId}');
      print('  accessSourceId: ${result.accessSourceId}');
      print('  error: ${result.error}');

      await refreshCustomerAndPrintState(
        revenipe,
        label: 'After usage tracking',
      );
    });
  });*/

 /* group('11. Failed payment placeholders', () {
    test('manual Stripe failed payment scenarios', () {
      print('Manual failed payment cases to run later with Stripe test cards:');
      print('');
      print('1) Subscription Checkout failed/canceled');
      print('   - Open Checkout and cancel or use a failing test card.');
      print('   - Expected: no active subscription source should be created.');
      print('');
      print('2) Immediate upgrade payment failed');
      print('   - Trigger Basic -> Pro upgrade with a payment method that fails.');
      print('   - Expected: invoice.payment_failed should not expire current access.');
      print('   - Expected: backend reverts Stripe item and clears PendingPlanChange.');
      print('');
      print('3) One-off product failed');
      print('   - Start one-off product Checkout and fail/cancel payment.');
      print('   - Expected: no one-off product access source should be created.');
      print('');
      print('4) One-off add-on failed');
      print('   - Start one-off add-on Checkout and fail/cancel payment.');
      print('   - Expected: no one-off add-on source/top-up should be created.');
      print('');
      print('5) Initial recurring add-on failed');
      print('   - Start recurring add-on purchase and fail the first invoice/payment.');
      print('   - Expected: failed subscription item should be deleted.');
      print('   - Expected: no active recurring add-on source should exist.');
      print('');
      print('6) Renewal payment failed');
      print('   - Let Stripe simulate renewal failure/dunning.');
      print('   - Expected: invoice.payment_failed keeps access for now.');
      print(
        '   - Expected: access expires only after Stripe cancels and sends '
        'customer.subscription.deleted.',
      );
    });
  });*/
}

Future<void> setupRevenipe(Revenipe revenipe) async {
  final effectiveBaseUrl = _isEmpty(baseUrl)
      ? 'https://api.revenipe.com/'
      : baseUrl;

  await revenipe.configure(
    config: RevenipeConfig(
      appId: appKey,
      baseUrl: effectiveBaseUrl,
      enableLogging: true,
    ),
  );

  print('Revenipe configured.');
  print('  baseUrl: $effectiveBaseUrl');
  print('  appKey set: ${appKey.isNotEmpty}');
}

Future<RevenipeCustomer> loginTestCustomer(Revenipe revenipe) async {
  print('Logging in test customer: $customerId');

  final customer = await revenipe.login(customerId);

  printCustomerState(customer, label: 'Logged-in customer');

  return customer;
}

Future<AppProductsResponse> fetchAndPrintProducts(Revenipe revenipe) async {
  final response = await revenipe.getProducts();

  print('Products (${response.products.length}):');

  if (response.products.isEmpty) {
    print('  No products returned.');
    return response;
  }

  for (final product in response.products) {
    print(
      '  - id=${product.productId}, '
      'name=${product.name}, '
      'type=${product.type}, '
      'price=${product.price}, '
      'interval=${product.recurringInterval}',
    );

    for (final entitlement in product.entitlements) {
      print(
        '      entitlement=${entitlement.entitlementId}, '
        'name=${entitlement.name}',
      );
    }
  }

  return response;
}

Future<RevenipeCustomer> refreshCustomerAndPrintState(
  Revenipe revenipe, {
  required String label,
}) async {
  if (_isEmpty(customerId)) {
    throw StateError('customerId placeholder is empty.');
  }

  final customer = await revenipe.login(customerId);

  printCustomerState(customer, label: label);

  return customer;
}

Future<StartPurchaseResponse> startCheckoutPurchase(
  Revenipe revenipe, {
  required String productId,
  TrialPaymentMethodBehavior? trialPaymentMethodBehavior,
}) {
  return revenipe.startPurchase(
    options: MakePurchaseOptions(
      productId: productId,
      method: RevenipePurchaseMethod.hostedCheckout,
      customerId: customerId,
      successUrl: successUrl,
      cancelUrl: cancelUrl,
      trialPaymentMethodBehavior: trialPaymentMethodBehavior,
    ),
  );
}

Future<void> handleCheckoutIfPresent(
  Revenipe revenipe,
  StartPurchaseResponse response,
) async {
  final checkoutUrl = response.checkout?.checkoutUrl;

  if (_isEmpty(checkoutUrl)) {
    print('No Checkout URL returned for this response.');
    return;
  }

  await openCheckoutUrl(checkoutUrl!);
  await waitForWebhookProcessing();

  await refreshCustomerAndPrintState(
    revenipe,
    label: 'After Checkout + webhook wait',
  );
}

Future<void> openCheckoutUrl(String checkoutUrl) async {
  print('Stripe Checkout URL:');
  print(checkoutUrl);

  if (!openCheckoutInBrowser) {
    print('openCheckoutInBrowser=false. Open the URL manually.');
    return;
  }

  try {
    final opened = await _openUrlWithPlatformBrowser(checkoutUrl);

    if (opened) {
      print('Checkout URL opened in browser if the host OS allowed it.');
    } else {
      print(
        'Could not auto-open Checkout URL. Open it manually from the log above.',
      );
    }
  } catch (error) {
    print('Could not auto-open Checkout URL: $error');
    print('Open it manually from the log above.');
  }

  print(
    'Complete the Stripe Checkout payment manually, then this test waits '
    '$webhookWaitSeconds seconds for webhook processing.',
  );
}

Future<bool> _openUrlWithPlatformBrowser(String url) async {
  if (Platform.isMacOS) {
    final result = await Process.run('open', [url]);
    return result.exitCode == 0;
  }

  if (Platform.isWindows) {
    final result = await Process.run('cmd', ['/c', 'start', '', url]);
    return result.exitCode == 0;
  }

  if (Platform.isLinux) {
    final result = await Process.run('xdg-open', [url]);
    return result.exitCode == 0;
  }

  return false;
}

Future<void> waitForWebhookProcessing() async {
  print('Waiting $webhookWaitSeconds seconds for Revenipe webhook processing...');
  await Future<void>.delayed(const Duration(seconds: webhookWaitSeconds));
}

Future<void> expectTrialPlanChangeBlocked(
  Revenipe revenipe, {
  required RevenipeCustomer customer,
  required String fromProductId,
  required String targetProductId,
}) async {
  print(
    'Trying trial plan change that should be blocked: '
    '$fromProductId -> $targetProductId',
  );

  try {
    final response = await revenipe.changeSubscription(
      fromProductId: fromProductId,
      newProductId: targetProductId,
    );

    print('WARNING: trial plan change was not blocked. Response:');
    printChangeSubscriptionResponse(response);
  } catch (error) {
    print('Trial plan change blocked as expected. Error: $error');
    expect(error, isNotNull);
  }
}

void printPurchaseResponse(StartPurchaseResponse response) {
  print('StartPurchaseResponse:');
  print('  purchaseMethod: ${response.purchaseMethod}');
  print('  productId: ${response.productId}');
  print('  productType: ${response.productType}');

  if (response.checkout != null) {
    print('  checkout.sessionId: ${response.checkout!.sessionId}');
    print('  checkout.checkoutUrl: ${response.checkout!.checkoutUrl}');
  } else {
    print('  checkout: null');
  }

  if (response.setup != null) {
    print('  setup.customerId: ${response.setup!.customerId}');
    print('  setup.setupIntentId: ${response.setup!.setupIntentId}');
    print(
      '  setup.setupIntentClientSecret set: '
      '${response.setup!.setupIntentClientSecret.isNotEmpty}',
    );
  } else {
    print('  setup: null');
  }

  if (response.subscription != null) {
    print(
      '  subscription.subscriptionId: '
      '${response.subscription!.subscriptionId}',
    );
    print('  subscription.status: ${response.subscription!.status}');
    print('  subscription.trialEnd: ${response.subscription!.trialEnd}');
  } else {
    print('  subscription: null');
  }

  if (response.paymentSheet != null) {
    print(
      '  paymentSheet returned, but this test file intentionally does not run '
      'PaymentSheet flows.',
    );
  }
}

void printChangeSubscriptionResponse(ChangeSubscriptionPlanResponse response) {
  print('ChangeSubscriptionPlanResponse:');
  print('  success: ${response.success}');
  print('  changeType: ${response.changeType}');
  print('  billingMode: ${response.billingMode}');
  print('  status: ${response.status}');
  print('  effectiveAt: ${response.effectiveAt}');
  print('  isImmediate: ${response.isImmediate}');
  print('  isScheduled: ${response.isScheduled}');
  print('  message: ${response.message}');
}

void printCustomerState(RevenipeCustomer customer, {required String label}) {
  print('--- $label ---');
  print('customerId: ${customer.customerId}');

  print('subscriptions (${customer.subscriptions.length}):');
  for (final subscription in customer.subscriptions) {
    print('  - ${formatSubscription(subscription)}');
  }

  print('addOns (${customer.addOns.length}):');
  for (final addOn in customer.addOns) {
    print('  - ${formatAddOn(addOn)}');
  }

  print('entitlements (${customer.entitlements.length}):');
  for (final entitlement in customer.entitlements) {
    print('  - ${formatEntitlement(entitlement)}');
  }

  print('usageKeys (${customer.usageKeys.length}):');
  for (final usageKey in customer.usageKeys) {
    print('  - ${formatUsageKey(usageKey)}');
  }

  print('--- end $label ---');
}

String formatSubscription(CustomerSubscription? subscription) {
  if (subscription == null) return 'null';

  final pending = subscription.pendingChange;

  final pendingText = pending == null
      ? 'none'
      : 'type=${pending.type}, '
          'billingMode=${pending.billingMode}, '
          'status=${pending.status}, '
          'from=${pending.fromProductId}, '
          'to=${pending.toProductId}, '
          'effectiveAt=${pending.effectiveAt}';

  return 'productId=${subscription.productId}, '
      'name=${subscription.productName}, '
      'status=${subscription.status}, '
      'provider=${subscription.provider}, '
      'isTrial=${subscription.isTrial}, '
      'renewsAt=${subscription.renewsAt}, '
      'expiresAt=${subscription.expiresAt}, '
      'willCancelAtPeriodEnd=${subscription.willCancelAtPeriodEnd}, '
      'canCancel=${subscription.canCancel}, '
      'pendingChange=[$pendingText]';
}

String formatAddOn(CustomerAddOn? addOn) {
  if (addOn == null) return 'null';

  return 'productId=${addOn.productId}, '
      'name=${addOn.productName}, '
      'status=${addOn.status}, '
      'billingType=${addOn.billingType}, '
      'renewsAt=${addOn.renewsAt}, '
      'expiresAt=${addOn.expiresAt}, '
      'canCancel=${addOn.canCancel}';
}

String formatEntitlement(CustomerEntitlement? entitlement) {
  if (entitlement == null) return 'null';

  return 'entitlementId=${entitlement.entitlementId}, '
      'type=${entitlement.type}, '
      'remaining=${entitlement.remaining}, '
      'expiresAt=${entitlement.expiresAt}';
}

String formatUsageKey(UsageKey? usageKey) {
  if (usageKey == null) return 'null';

  return 'usageKeyId=${usageKey.usageKeyId}, '
      'name=${usageKey.name}, '
      'remaining=${usageKey.remaining}';
}

CustomerSubscription? _findSubscription(
  RevenipeCustomer customer,
  String productId,
) {
  final matches = customer.subscriptions.where(
    (item) => item.productId == productId,
  );

  return matches.isEmpty ? null : matches.first;
}

bool _canRunProductFlow(String productId, String placeholderName) {
  if (!_hasRequiredSetupPlaceholders) {
    _printSkip(
      placeholderName,
      'Fill baseUrl, appKey, and customerId first.',
    );
    return false;
  }

  if (_isEmpty(productId)) {
    _printSkip(placeholderName, 'Fill $placeholderName.');
    return false;
  }

  return true;
}

bool get _hasRequiredSetupPlaceholders {
  return !_isEmpty(baseUrl) && !_isEmpty(appKey) && !_isEmpty(customerId);
}

bool _isEmpty(String? value) {
  return value == null || value.trim().isEmpty;
}

void _printSkip(String flow, String reason) {
  print('SKIP: $flow. Reason: $reason');
}