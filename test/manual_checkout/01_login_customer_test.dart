import 'package:flutter_test/flutter_test.dart';

import 'manual_checkout_test_config.dart';
import 'manual_checkout_test_support.dart';

void main() {
  test('manual flow - login customer', () async {
    final loginIdentity = loginIdentityFor('login_customer');
    final revenipe = await loginWithExternalIdentity(loginIdentity);

    final products = await revenipe.getProducts();

    print('\nPRODUCTS RETURNED: ${products.products.length}');
    for (final product in products.products) {
      print(
        'product=${product.productId}, name=${product.name}, '
        'type=${product.type}, price=${product.price}, '
        'interval=${product.recurringInterval}',
      );
    }

    print('\nLogin flow finished. Review the printed session/client ID and products.');
  }, timeout: manualFlowTimeout);
}
