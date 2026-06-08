import 'package:revenipe_flutter/revenipe_flutter.dart';
import 'package:revenipe_flutter/src/core/respponses/refresh_entitlements_response.dart';

extension RevenipeCustomerRefreshUpdate on RevenipeCustomer {
  RevenipeCustomer updateFromRefreshResponse(
    RefreshClientEntitlementsResponse response,
  ) {
    return copyWith(
      entitlements: response.entitlements,
      usageKeys: response.usageKeys,
      subscriptions: response.subscriptions,
      addOns: response.addOns,
      basePlans: response.basePlans,
    );
  }
}