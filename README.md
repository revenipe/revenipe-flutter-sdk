![Revenipe Flutter SDK — Billing and entitlements for Flutter apps](https://raw.githubusercontent.com/revenipe/revenipe-flutter-sdk/main/assets/readme/revenipe_hero.png)

# Revenipe Flutter SDK

[![Pub release](https://img.shields.io/pub/v/revenipe_flutter.svg?style=flat-square)](https://pub.dev/packages/revenipe_flutter)
[![Flutter SDK](https://img.shields.io/badge/Flutter-SDK-02569B?style=flat-square\&logo=flutter\&logoColor=white)](https://flutter.dev)
[![Documentation](https://img.shields.io/badge/docs-docs.revenipe.com-2F7BFF?style=flat-square)](https://docs.revenipe.com)
[![Discord](https://img.shields.io/badge/Discord-Join%20community-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.com/invite/CzTUUPWYxS)
[![GitHub](https://img.shields.io/badge/GitHub-revenipe--flutter--sdk-111827?style=flat-square\&logo=github)](https://github.com/revenipe/revenipe-flutter-sdk)
[![License](https://img.shields.io/badge/License-MIT-111827?style=flat-square)](LICENSE)

> ### Billing and entitlements made simple
>
> Build products in the dashboard. Connect your Flutter app. Let Revenipe handle subscriptions, trials, one-off payments, usage limits and customer access state.

Revenipe is a monetization backend and Flutter SDK for apps using **Stripe** and **RevenueCat**. It gives your app one clean customer model for products, purchases, subscriptions, entitlements and usage-based features — without building the billing backend yourself.


![Configure, connect and collect with Revenipe](https://raw.githubusercontent.com/revenipe/revenipe-flutter-sdk/main/assets/readme/go_live_in_3_steps.png)

## Features

* **Subscriptions and one-off payments**
* **Hosted Checkout** for the fastest launch path
* **PaymentSheet responses** for native Stripe payment UI
* **Direct trials** and SetupIntent-based trial flows
* **Attach payment methods** to direct-trial subscriptions
* **Entitlements** for feature access
* **Usage keys and limits** for credits, exports, API calls and more
* **Subscription plan changes and cancellation**
* **Stripe and RevenueCat** support through one backend layer

## Quick start

### Install

```yaml
flutter pub add revenipe_flutter
```

```dart
import 'package:revenipe_flutter/revenipe_flutter.dart';
```

### Configure the SDK

Configure Revenipe once during app startup:

```dart
final revenipe = Revenipe.instance;

await revenipe.configure(
  config: const RevenipeConfig(
    appId: 'app_your_public_app_id',
  ),
);
```


### Identify a customer

Use a stable identifier from your own authentication system:

```dart
final customer = await revenipe.login('user_123');
```

Or create an anonymous customer session:

```dart
final customer = await revenipe.anonymLogin();
```

After login, Revenipe stores the active customer session internally:

```dart
final currentCustomer = revenipe.customer;
```

## Products

Fetch the products configured in the Revenipe dashboard:

```dart
final response = await revenipe.getProducts();

for (final product in response.products) {
  print('${product.name}: ${product.productId}');
}
```

Products can represent recurring subscriptions, one-off purchases or other monetization options configured for your app.

## Purchases

Revenipe supports two Stripe purchase experiences:

| Purchase method | Best for                                        | Your app handles               |
| --------------- | ----------------------------------------------- | ------------------------------ |
| Hosted Checkout | Fastest integration and redirect-based payments | Opening the returned URL       |
| PaymentSheet    | Native in-app payment UI                        | Presenting Stripe PaymentSheet |

### Hosted Checkout

```dart
final response = await revenipe.startPurchase(
  options: MakePurchaseOptions(
    customerId: customer.customerId,
    productId: 'pro_monthly',
    method: RevenipePurchaseMethod.hostedCheckout,
    successUrl: 'myapp://billing/success',
    cancelUrl: 'myapp://billing/cancel',
  ),
);

final checkoutUrl = response.checkout!.checkoutUrl;
```

Open the returned Checkout URL with your navigation flow, for example with `url_launcher`:

```dart
await launchUrl(
  Uri.parse(checkoutUrl),
  mode: LaunchMode.externalApplication,
);
```

After the customer returns to your app, load their latest Revenipe state:

```dart
final updatedEntitlements = await revenipe.refreshEntitlements();
```

### PaymentSheet

For native payment UI, request a PaymentSheet purchase flow:

```dart
final response = await revenipe.startPurchase(
  options: MakePurchaseOptions(
    customerId: customer.customerId,
    productId: 'pro_monthly',
    method: RevenipePurchaseMethod.paymentSheet,
  ),
);

final paymentSheet = response.paymentSheet!;
```

Your app can then present Stripe PaymentSheet using [`flutter_stripe`](https://pub.dev/packages/flutter_stripe):

```dart
await Stripe.instance.initPaymentSheet(
  paymentSheetParameters: SetupPaymentSheetParameters(
    merchantDisplayName: 'My App',
    customerId: paymentSheet.customerId,
    customerEphemeralKeySecret:
        paymentSheet.customerEphemeralKeySecret,
    paymentIntentClientSecret:
        paymentSheet.paymentIntentClientSecret,
  ),
);

await Stripe.instance.presentPaymentSheet();
```

Apps using PaymentSheet must complete the native Android and iOS setup required by `flutter_stripe`. Apps using only Hosted Checkout do not need to implement native PaymentSheet UI.

## Trial subscriptions

Revenipe supports subscription trials with or without a payment method collected upfront.

### Direct trial

A direct trial starts immediately without collecting payment details first:

```dart
final response = await revenipe.startPurchase(
  options: MakePurchaseOptions(
    customerId: customer.customerId,
    productId: 'pro_monthly',
    method: RevenipePurchaseMethod.hostedCheckout,
    trialPaymentMethodBehavior: TrialPaymentMethodBehavior.direct,
  ),
);
```

If no payment method is attached before the trial ends, the subscription can be canceled according to your Stripe trial configuration.

### SetupIntent trial

A SetupIntent trial collects a payment method before the subscription trial is created:

```dart
final response = await revenipe.startPurchase(
  options: MakePurchaseOptions(
    customerId: customer.customerId,
    productId: 'pro_monthly',
    method: RevenipePurchaseMethod.paymentSheet,
    trialPaymentMethodBehavior: TrialPaymentMethodBehavior.setupIntent,
  ),
);

final setup = response.setup!;
```

Present the setup flow through Stripe PaymentSheet:

```dart
await Stripe.instance.initPaymentSheet(
  paymentSheetParameters: SetupPaymentSheetParameters(
    merchantDisplayName: 'My App',
    customerId: setup.customerId,
    customerEphemeralKeySecret: setup.ephemeralKey,
    setupIntentClientSecret: setup.setupIntentClientSecret,
  ),
);

await Stripe.instance.presentPaymentSheet();
```

## Attach a payment method to a direct trial

When a customer started a direct trial without a payment method, attach one before the trial ends so the subscription can continue.

Revenipe automatically resolves the eligible trial subscription when exactly one is available.

### Attach with Hosted Checkout

```dart
final response = await revenipe.attachPaymentMethodToSubscription(
  options: const AttachPaymentMethodOptions(
    method: RevenipePurchaseMethod.hostedCheckout,
    successUrl: 'myapp://billing/payment-method/success',
    cancelUrl: 'myapp://billing/payment-method/cancel',
  ),
);

final checkoutUrl = response.checkout!.checkoutUrl;
```

Open the returned URL:

```dart
await launchUrl(
  Uri.parse(checkoutUrl),
  mode: LaunchMode.externalApplication,
);
```

### Attach with PaymentSheet

```dart
final response = await revenipe.attachPaymentMethodToSubscription(
  options: const AttachPaymentMethodOptions(
    method: RevenipePurchaseMethod.paymentSheet,
  ),
);

final paymentSheet = response.paymentSheet!;
```

Present the SetupIntent PaymentSheet:

```dart
await Stripe.instance.initPaymentSheet(
  paymentSheetParameters: SetupPaymentSheetParameters(
    merchantDisplayName: 'My App',
    customerId: paymentSheet.customerId,
    customerEphemeralKeySecret:
        paymentSheet.customerEphemeralKeySecret,
    setupIntentClientSecret:
        paymentSheet.setupIntentClientSecret!,
  ),
);

await Stripe.instance.presentPaymentSheet();
```

If the customer has multiple eligible trial subscriptions, select the product explicitly:

```dart
final response = await revenipe.attachPaymentMethodToSubscription(
  productId: 'pro_monthly',
  options: const AttachPaymentMethodOptions(
    method: RevenipePurchaseMethod.hostedCheckout,
    successUrl: 'myapp://billing/payment-method/success',
    cancelUrl: 'myapp://billing/payment-method/cancel',
  ),
);
```

Payment-method attachment is finalized asynchronously after Stripe confirms the SetupIntent. Refresh the customer to read the updated subscription state:

```dart
final updatedEntitlements = await revenipe.refreshEntitlements();

final subscription = updatedEntitlements.subscriptions.firstWhere(
  (subscription) => subscription.productId == 'pro_monthly',
);

print(subscription.paymentMethodAttached);
```

## Entitlements

Revenipe entitlements allow your app to unlock features from the current customer session.

Check whether the customer has access:

```dart
if (revenipe.hasEntitlement('export_hd')) {
  // Unlock HD exports.
}
```

Read the entitlement details:

```dart
final entitlement = revenipe.getEntitlement('image_exports');

if (entitlement != null) {
  print('Remaining: ${entitlement.remaining}');
}
```

## Usage tracking

Track usage for an entitlement or configured usage key:

```dart
final result = await revenipe.track('ai_credits', 1);

if (result.success) {
  print('Remaining: ${result.remaining}');
}
```

Read a usage key from the current customer session:

```dart
final credits = revenipe.getUsageKey('ai_credits');

if (credits != null) {
  print('Credits remaining: ${credits.remaining}');
}
```

This works well for features such as:

* AI credits
* image exports
* API request limits
* document generations
* processing minutes
* consumable unlocks

## Subscription management

### Change a subscription plan

When the customer has exactly one active or trialing subscription, Revenipe resolves it automatically:

```dart
final result = await revenipe.changeSubscription(
  newProductId: 'pro_yearly',
);
```

If the customer has multiple active subscriptions, specify the subscription to change:

```dart
final result = await revenipe.changeSubscription(
  fromProductId: 'pro_monthly',
  newProductId: 'pro_yearly',
);
```

The response indicates whether the change is immediate or scheduled for the end of the current billing period:

```dart
if (result.isImmediate) {
  print('Plan change is being applied immediately.');
}

if (result.isScheduled) {
  print('Plan change is scheduled for ${result.effectiveAt}.');
}
```

### Cancel a subscription

Cancel at the end of the current billing period:

```dart
final result = await revenipe.cancelSubscription(
  productId: 'pro_monthly',
);
```

Or cancel immediately:

```dart
final result = await revenipe.cancelSubscription(
  productId: 'pro_monthly',
  cancelMode: SubscriptionCancelMode.immediately,
);
```

Reload the customer after billing changes to retrieve the latest subscription and entitlement state:

```dart
final updatedEntitlements = await revenipe.refreshEntitlements();
```

## Local customer state

Once a customer is identified, you can access their state from the SDK instance:

```dart
final customer = revenipe.customer;

final hasPro = revenipe.hasSubscription('pro_monthly');
final subscription = revenipe.getSubscription('pro_monthly');
final basePlan = customer?.currentBasePlan;
```

Clear the in-memory session when the user signs out:

```dart
revenipe.clearSession();
```

## License

Revenipe Flutter SDK is available under the [MIT License](LICENSE).

## Platform billing note

Apps selling digital goods, subscriptions or premium digital functionality may be subject to Apple App Store and Google Play billing rules.

Select Stripe, RevenueCat or store billing flows according to your distribution platform, product type and applicable store requirements.

## Documentation

Detailed setup guides and dashboard documentation are available at:

**[docs.revenipe.com](https://docs.revenipe.com)**

## Homepage

**[revenipe.com](https://revenipe.com)**

## Repository

Source code and issue tracking:

**[github.com/revenipe/revenipe-flutter-sdk](https://github.com/revenipe/revenipe-flutter-sdk)**

