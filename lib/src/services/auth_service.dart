import 'package:revenipe_flutter/src/models/models.dart';

import '../network/revenipe_http_client.dart';

class AuthService {
  AuthService(this._client);

  final RevenipeHttpClient _client;

  static const String _clientBasePath = 'v1/client/';

  Future<RevenipeCustomer> loginCustomer(String customerId) {
    return _client.post<RevenipeCustomer>(
      path: '${_clientBasePath}auth',
      data: <String, dynamic>{'client_id': customerId},
      parser: (data) => RevenipeCustomer.fromJson(data as Map<String, dynamic>),
    );
  }
}
