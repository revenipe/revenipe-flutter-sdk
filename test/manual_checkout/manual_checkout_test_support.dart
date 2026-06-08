import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:revenipe_flutter/revenipe_flutter.dart';

import 'manual_checkout_test_config.dart';

const Timeout manualFlowTimeout = Timeout(Duration(minutes: 10));

void requireConfigValue(String value, String name) {
  if (value.trim().isEmpty) {
    throw StateError(
      'Missing $name. Paste it into manual_checkout_test_config.dart first.',
    );
  }
}

Future<Revenipe> loginWithExternalIdentity(String loginIdentity) async {
  requireConfigValue(baseUrl, 'baseUrl');
  requireConfigValue(appKey, 'appKey');
  requireConfigValue(loginIdentity, 'loginIdentity');

  final revenipe = Revenipe.instance;

  await revenipe.configure(
    config: RevenipeConfig(
      appId: appKey,
      baseUrl: baseUrl,
      enableLogging: true,
    ),
  );

  print('\nLOGIN');
  print('External login identity sent to revenipe.login(...): $loginIdentity');

  final customer = await revenipe.login(loginIdentity);

  print(
    'Internal Revenipe client ID returned and stored in session: '
    '${revenipe.currentCustomerId}',
  );
  printCustomerState(customer, label: 'Customer after login');

  return revenipe;
}

String activeSessionClientId(Revenipe revenipe) {
  final clientId = revenipe.currentCustomerId;

  if (clientId == null || clientId.trim().isEmpty) {
    throw StateError(
      'No active internal Revenipe client ID. Call login first.',
    );
  }

  return clientId;
}

Future<RevenipeCustomer> refreshByExternalIdentity(
  Revenipe revenipe,
  String loginIdentity, {
  required String label,
}) async {
  print('\nREFRESH');
  print('Re-login uses external identity: $loginIdentity');

  final customer = await revenipe.login(loginIdentity);

  print('Refreshed internal client ID in session: ${revenipe.currentCustomerId}');
  printCustomerState(customer, label: label);

  return customer;
}

Future<StartPurchaseResponse> startHostedCheckoutPurchase(
  Revenipe revenipe, {
  required String productId,
  TrialPaymentMethodBehavior? trialPaymentMethodBehavior,
}) async {
  requireConfigValue(productId, 'productId');

  final internalClientId = activeSessionClientId(revenipe);

  print('\nSTART PURCHASE');
  print('Product ID: $productId');
  print('customer_id sent to purchase API (internal session client ID): $internalClientId');

  final response = await revenipe.startPurchase(
    options: MakePurchaseOptions(
      productId: productId,
      method: RevenipePurchaseMethod.hostedCheckout,
      successUrl: successUrl,
      cancelUrl: cancelUrl,
      trialPaymentMethodBehavior: trialPaymentMethodBehavior,
    ),
  );

  printPurchaseResponse(response);
  return response;
}

Future<void> openCheckoutIfReturned(StartPurchaseResponse response) async {
  final url = response.checkout?.checkoutUrl;
  if (url == null || url.trim().isEmpty) {
    print('\nNo hosted Checkout URL returned. Nothing to open in browser.');
    return;
  }

  await openUrlAndWait(url);
}

Future<void> openAttachCheckoutIfReturned(
  AttachPaymentMethodToSubscriptionResponse response,
) async {
  final url = response.checkout?.checkoutUrl;
  if (url == null || url.trim().isEmpty) {
    print('\nNo hosted Checkout URL returned for payment-method attachment.');
    return;
  }

  await openUrlAndWait(url);
}

Future<void> openUrlAndWait(String url) async {
  print('\nSTRIPE CHECKOUT URL');
  print(url);

  if (openCheckoutInBrowser) {
    try {
      final opened = await openInPlatformBrowser(url);
      print(
        opened
            ? 'Browser opened. Complete the Stripe flow now.'
            : 'Browser did not auto-open. Copy the URL above manually.',
      );
    } catch (error) {
      print('Could not auto-open browser: $error');
      print('Copy the URL above manually.');
    }
  } else {
    print('openCheckoutInBrowser is false. Open the URL manually.');
  }

  print('Waiting $checkoutWaitSeconds seconds for manual Checkout/webhook processing...');
  await Future<void>.delayed(const Duration(seconds: checkoutWaitSeconds));
}

Future<void> waitForWebhookRefresh() async {
  print('Waiting $webhookRefreshWaitSeconds seconds before refreshing...');
  await Future<void>.delayed(
    const Duration(seconds: webhookRefreshWaitSeconds),
  );
}

Future<bool> openInPlatformBrowser(String url) async {
  if (Platform.isMacOS) {
    return (await Process.run('open', [url])).exitCode == 0;
  }

  if (Platform.isWindows) {
    return (await Process.run('cmd', ['/c', 'start', '', url])).exitCode == 0;
  }

  if (Platform.isLinux) {
    return (await Process.run('xdg-open', [url])).exitCode == 0;
  }

  return false;
}

void printPurchaseResponse(StartPurchaseResponse response) {
  print('\nPURCHASE RESPONSE');
  print('purchaseMethod: ${response.purchaseMethod}');
  print('productId: ${response.productId}');
  print('productType: ${response.productType}');
  print('checkoutUrl: ${response.checkout?.checkoutUrl}');
  print('setupIntentId: ${response.setup?.setupIntentId}');
  print('subscriptionStatus: ${response.subscription?.status}');
  if (response.paymentSheet != null) {
    print('PaymentSheet response returned. This command-line script does not present native PaymentSheet UI.');
  }
}

void printAttachResponse(AttachPaymentMethodToSubscriptionResponse response) {
  print('\nATTACH PAYMENT METHOD RESPONSE');
  print('purchaseMethod: ${response.purchaseMethod}');
  print('checkoutUrl: ${response.checkout?.checkoutUrl}');
  print('paymentSheet returned: ${response.paymentSheet != null}');
}

void printCancelResponse(CancelSubscriptionResponse response) {
  print('\nCANCEL RESPONSE');
  print('success: ${response.success}');
  print('status: ${response.status}');
  print('willCancelAtPeriodEnd: ${response.willCancelAtPeriodEnd}');
  print('cancelsAt: ${response.cancelsAt}');
  print('message: ${response.message}');
}

void printChangeResponse(ChangeSubscriptionPlanResponse response) {
  print('\nPLAN CHANGE RESPONSE');
  print('success: ${response.success}');
  print('changeType: ${response.changeType}');
  print('billingMode: ${response.billingMode}');
  print('status: ${response.status}');
  print('effectiveAt: ${response.effectiveAt}');
  print('isImmediate: ${response.isImmediate}');
  print('isScheduled: ${response.isScheduled}');
  print('message: ${response.message}');
}

void printCustomerState(RevenipeCustomer customer, {required String label}) {
  print('\n--- $label ---');
  print('internal clientId: ${customer.customerId}');

  print('base plans: ${customer.basePlans.length}');
  for (final basePlan in customer.basePlans) {
    print('  product=${basePlan.productId}, status=${basePlan.status}');
  }

  print('subscriptions: ${customer.subscriptions.length}');
  for (final subscription in customer.subscriptions) {
    print(
      '  product=${subscription.productId}, status=${subscription.status}, '
      'trial=${subscription.isTrial}, paymentAttached=${subscription.paymentMethodAttached}, '
      'cancelAtPeriodEnd=${subscription.willCancelAtPeriodEnd}, '
      'pendingChange=${subscription.pendingChange?.toProductId}, '
      'source=${subscription.accessSourceId}',
    );
  }

  print('entitlements: ${customer.entitlements.length}');
  for (final entitlement in customer.entitlements) {
    print(
      '  id=${entitlement.entitlementId}, type=${entitlement.type}, '
      'remaining=${entitlement.remaining}, source=${entitlement.accessSourceId}',
    );
  }

  print('usage keys: ${customer.usageKeys.length}');
  for (final usageKey in customer.usageKeys) {
    print('  id=${usageKey.usageKeyId}, remaining=${usageKey.remaining}');
  }

  print('--- end $label ---\n');
}
