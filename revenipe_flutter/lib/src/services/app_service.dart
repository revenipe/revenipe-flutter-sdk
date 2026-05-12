import 'package:revenipe_flutter/revenipe_flutter.dart';
import 'package:revenipe_flutter/src/core/respponses/app_products_response.dart';
import 'package:revenipe_flutter/src/core/respponses/track_respopnse.dart';
import '../network/revenipe_http_client.dart';

class AppService {
  AppService(this._client);

  final RevenipeHttpClient _client;

  static const String _clientBasePath = 'v1/customer/app/';

  Future<AppProductsResponse> getProducts() {
    return _client.get<AppProductsResponse>(
      path: '${_clientBasePath}products',
      parser: (data) => AppProductsResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<AppProductsResponse> startPurchase() {
    return _client.get<AppProductsResponse>(
      path: '${_clientBasePath}products',
      parser: (data) => AppProductsResponse.fromJson(data as Map<String, dynamic>),
    );
  }
}
