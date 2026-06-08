# Revenipe manual Checkout scripts

These scripts are manual end-to-end flows, not assertion tests. They intentionally contain **no `expect(...)` calls**. Run one file, complete Stripe Checkout in your browser, then review the printed Revenipe customer state.

## Correct customer ID handling

The scripts distinguish between:

```dart
final loginIdentity = loginIdentityFor('normal_subscription');
await revenipe.login(loginIdentity);
```

and:

```dart
final internalClientId = revenipe.currentCustomerId!;
```

`loginIdentity` is the external identity used to log the end customer into Revenipe. After login, the returned active session contains Revenipe's internal client ID. `MakePurchaseOptions.customerId` uses that current internal session ID.

When customer data needs to be refreshed after Stripe/webhook processing, the scripts call:

```dart
await revenipe.login(loginIdentity);
```

again using the original external identity. They do not log in with the internal returned client ID.

## Configure

Edit:

```text
test/manual_checkout/manual_checkout_test_config.dart
```

Set your app key and product/entitlement IDs. Change `runId` when you want completely new identities for another full test pass.

## Run separately

```bash
flutter test test/manual_checkout/01_login_customer_test.dart
flutter test test/manual_checkout/02_start_normal_subscription_test.dart
flutter test test/manual_checkout/03_start_direct_trial_test.dart
flutter test test/manual_checkout/04_start_setup_trial_test.dart
flutter test test/manual_checkout/05_attach_payment_method_to_direct_trial_test.dart
flutter test test/manual_checkout/06_one_off_purchase_test.dart
flutter test test/manual_checkout/07_cancel_subscription_immediately_test.dart
flutter test test/manual_checkout/08_cancel_subscription_at_period_end_test.dart
flutter test test/manual_checkout/09_upgrade_subscription_test.dart
flutter test test/manual_checkout/10_downgrade_subscription_test.dart
flutter test test/manual_checkout/11_tracking_entitlement_test.dart
```

## Included SDK fix required for the attach flow

Your current `lib/src/services/purchase_service.dart` serializes the attach-payment-method `mode` incorrectly:

```dart
'mode': sourceId,
```

The ZIP overlay includes the corrected source file:

```dart
'mode': mode,
```

Without that fix, the hosted Checkout attach-payment-method request cannot send `hosted_checkout` correctly.

## PaymentSheet

These scripts target hosted Checkout because `flutter test` is suitable for browser/manual Checkout continuation. Stripe PaymentSheet is native UI and must be presented from a running Flutter app on a simulator/device. Test that in an example app or integration-test harness, with the final native PaymentSheet interaction completed manually unless you add platform-level UI automation.
