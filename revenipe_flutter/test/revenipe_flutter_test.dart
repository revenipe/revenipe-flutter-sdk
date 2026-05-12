import 'package:flutter_test/flutter_test.dart';
import 'package:revenipe_flutter/revenipe_flutter.dart';
import 'package:revenipe_flutter/src/purchase/purchase_method.dart';
import 'package:revenipe_flutter/src/purchase/purchase_options.dart';
import 'package:revenipe_flutter/src/purchase/trial_payment_behavior.dart';

void main() {
  test('config can be created', () {
    const config = RevenipeConfig(
      appId: 'rk_sandbox_adzCE2AZ9aTDCU6VOYzc5cUtL4xplTLUR7-NNUJUenr9_TvU',
    );
    expect(
      config.appId,
      'rk_sandbox_adzCE2AZ9aTDCU6VOYzc5cUtL4xplTLUR7-NNUJUenr9_TvU',
    );
    expect(config.baseUrl, 'https://api.revenipe.com/');
    print('config correct. AppId: ${config.appId}');
  });

  test('user is able to log in', () async {
    final revenipe = Revenipe.instance;

    await revenipe.configure(
      config: const RevenipeConfig(
        appId: 'rk_sandbox_adzCE2AZ9aTDCU6VOYzc5cUtL4xplTLUR7-NNUJUenr9_TvU',
      ),
    );

    
  });

  test('Creating Basic Subscription', () async {
    final revenipe = Revenipe.instance;

    await revenipe.configure(
      config: const RevenipeConfig(
        appId: 'rk_sandbox_adzCE2AZ9aTDCU6VOYzc5cUtL4xplTLUR7-NNUJUenr9_TvU',
      ),
    );
    final hasPremium = Revenipe.instance.hasEntitlement('premium_access');

    final customer = await revenipe.login('2d4403a7bd2d425cb433a2837c50e46e');

    print('customer entitlement count: ${customer.entitlements.length}');

    print('customer subscription count: ${customer.subscriptions.length}');

    var response = await revenipe.cancelSubscription(customer: customer);

    print(response.success);

    //var response = await revenipe.changeSubscription(customer: customer, newProductId: 'basic_sub');

    //print(response.status);

    /* var response = await revenipe.startPurchase(
      options: MakePurchaseOptions(
        productId: 'pro_sub',
        method: RevenipePurchaseMethod.hostedCheckout,
        customerId: customer.customerId,
        successUrl: "https://revenipe.test.com/success",
        cancelUrl: "https://revenipe.test.com/canceled",
      ),
    );

    print(response.checkout!.checkoutUrl);*/
  });

  /*test('dashboard products can be fetched', () async {
    final revenipe = Revenipe.instance;

    await revenipe.configure(
      config: const RevenipeConfig(
        appId: 'rk_sandbox_adzCE2AZ9aTDCU6VOYzc5cUtL4xplTLUR7-NNUJUenr9_TvU',
      ),
    );

    final customer = await revenipe.login('062aa48ee57b4180a443c86d79899ac8');

    final products = await revenipe.getProducts();

    print('Product Count: ${products.products.length}');

    if (products.products.isNotEmpty) {
      for (var product in products.products) {
        print(
          "Product name: ${product.name}, Product ID: ${product.productId}",
        );
      }
    }
  });

  test('Purchase Test One Off Checkout', () async {
    final revenipe = Revenipe.instance;

    await revenipe.configure(
      config: const RevenipeConfig(
        appId: 'rk_sandbox_adzCE2AZ9aTDCU6VOYzc5cUtL4xplTLUR7-NNUJUenr9_TvU',
      ),
    );

    final customer = await revenipe.login('062aa48ee57b4180a443c86d79899ac8');

    var response = await revenipe.startPurchase(
      options: MakePurchaseOptions(
        productId: '500_credits_pack',
       
        method: RevenipePurchaseMethod.hostedCheckout,
        customerId: customer.customerId,
        successUrl: "https://revenipe.test.com/success",
        cancelUrl: "https://revenipe.test.com/canceled",
      ),
    );

    print("Checkout Url: ${response.checkout?.checkoutUrl ?? "null"}");
  });

  test('Purchase Test One Off Payment Sheet', () async {
    final revenipe = Revenipe.instance;

    await revenipe.configure(
      config: const RevenipeConfig(
        appId: 'rk_sandbox_adzCE2AZ9aTDCU6VOYzc5cUtL4xplTLUR7-NNUJUenr9_TvU',
      ),
    );

    final customer = await revenipe.login('062aa48ee57b4180a443c86d79899ac8');

    var response = await revenipe.startPurchase(
      options: MakePurchaseOptions(
        productId: '500_credits_pack',
        method: RevenipePurchaseMethod.paymentSheet,
        customerId: customer.customerId,
        successUrl: "https://revenipe.test.com/success",
        cancelUrl: "https://revenipe.test.com/canceled",
      ),
    );

    print("Client Secret: ${response.paymentSheet?.paymentIntentClientSecret ?? "null"}");
  });*/

  /* test('Purchase Test Recurring Checkout', () async {
    final revenipe = Revenipe.instance;

    await revenipe.configure(
      config: const RevenipeConfig(
        appId: 'rk_sandbox_adzCE2AZ9aTDCU6VOYzc5cUtL4xplTLUR7-NNUJUenr9_TvU',
      ),
    );

    final customer = await revenipe.login('062aa48ee57b4180a443c86d79899ac8');

    var response = await revenipe.startPurchase(
      options: MakePurchaseOptions(
        productId: 'scartaste_basic_deals',
       
        method: RevenipePurchaseMethod.hostedCheckout,
        customerId: customer.customerId,
        successUrl: "https://revenipe.test.com/success",
        cancelUrl: "https://revenipe.test.com/canceled",
      ),
    );

    print("Checkout Url Recurring: ${response.checkout?.checkoutUrl ?? "null"}");
  });*/
}
