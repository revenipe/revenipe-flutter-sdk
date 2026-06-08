import 'package:revenipe_flutter/revenipe_flutter.dart';
import 'package:revenipe_flutter/src/core/respponses/refresh_entitlements_response.dart';
import '../network/revenipe_http_client.dart';

class CustomerService {
  CustomerService(this._client);

  final RevenipeHttpClient _client;

  static const String _clientBasePath = 'v1/customer/';

  Future<TrackEntitlementResponse> track(
    RevenipeSession session,
    String entitlementId,
    int value,
  ) {
    var customer = session.customer;

    var result = customer.entitlements.where(
      (item) => item.entitlementId == entitlementId,
    );

    var entitlement = result.isNotEmpty ? result.first : null;

    return _client.post<TrackEntitlementResponse>(
      path: '${_clientBasePath}track',
      data: <String, dynamic>{
        'access_source_id': entitlement?.accessSourceId,
        'entitlement_id': entitlementId,
        'client_id': session.customerId,
        'value': value,
      },
      parser: (data) =>
          TrackEntitlementResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<RefreshClientEntitlementsResponse> refreshEntitlements(
    String customerId,
  ) {
    return _client.post<RefreshClientEntitlementsResponse>(
      path: '${_clientBasePath}refresh_entitlements',
      data: <String, dynamic>{'client_id': customerId},
      parser: (data) => RefreshClientEntitlementsResponse.fromJson(
        data as Map<String, dynamic>,
      ),
    );
  }
}
