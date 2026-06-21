import 'package:flutter_test/flutter_test.dart';
import 'package:revenipe_flutter/revenipe_flutter.dart';

void main() {
  var revenipe = Revenipe.instance;

  revenipe.configure(
    config: RevenipeConfig(
      appId:
          'app_sandbox_6a292ea2ea59795284a0d2ed53124f717bf8b0087547e583980ffd15e012f469eaa10af9',
      baseUrl: 'https://staging.revenipe.com/',
    ),
  );

  test('manual flow - login customer', () async {
    var user = await revenipe.login('test_customer_sdk');

    final products = await revenipe.getProducts();

    print('\nPRODUCTS RETURNED: ${products.products.length}');
    for (final product in products.products) {
      print(
        'product=${product.productId}, name=${product.name}, '
        'type=${product.type}, price=${product.price}, '
        'interval=${product.recurringInterval}',
      );
    }

    print(
      '\nLogin flow finished. Review the printed session/client ID and products.',
    );
  });
}
