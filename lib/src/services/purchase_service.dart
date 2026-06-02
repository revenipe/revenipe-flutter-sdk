import 'package:revenipe_flutter/revenipe_flutter.dart';
import 'package:revenipe_flutter/src/core/respponses/app_products_response.dart';
import 'package:revenipe_flutter/src/core/respponses/attach_payment_method_to_subscription_response.dart';
import 'package:revenipe_flutter/src/core/respponses/cancel_add_on_response.dart';
import 'package:revenipe_flutter/src/core/respponses/cancel_subscription_response.dart';
import 'package:revenipe_flutter/src/core/respponses/change_subscription_response.dart';
import 'package:revenipe_flutter/src/core/respponses/start_purchase_response.dart';
import 'package:revenipe_flutter/src/core/respponses/track_respopnse.dart';
import 'package:revenipe_flutter/src/core/utils/reslovers/cancel_add_on_reslover.dart';
import 'package:revenipe_flutter/src/core/utils/reslovers/cancel_subscription_reslover.dart';
import 'package:revenipe_flutter/src/core/utils/reslovers/from_subscription_reslover.dart';
import 'package:revenipe_flutter/src/purchase/attach_payment_method_options.dart';
import 'package:revenipe_flutter/src/purchase/purchase_options.dart';
import 'package:revenipe_flutter/src/purchase/subscription_cancel_mode.dart';
import '../network/revenipe_http_client.dart';

class PurchaseService {
  PurchaseService(this._client);

  final RevenipeHttpClient _client;

  static const String _clientBasePath = 'v1/customer/purchase/';

  Future<StartPurchaseResponse> startPurchase(MakePurchaseOptions options) {
    return _client.post<StartPurchaseResponse>(
      path: '${_clientBasePath}start_purchase',
      data: options.toJson(),
      parser: (data) =>
          StartPurchaseResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<AttachPaymentMethodToSubscriptionResponse>
  attachPaymentMethodToSubscription({
    required RevenipeCustomer customer,
    String? fromProductId,
    required AttachPaymentMethodOptions options,
  }) async {
    final subscription = resolveSubscriptionForPaymentMethodAttach(
      subscriptions: customer.subscriptions,
      fromProductId: fromProductId,
    );

    final request = _AttachPaymentMethodToSubscriptionPlanRequest(
      clientId: customer.customerId,
      sourceId: subscription.accessSourceId,
      successUrl: options.successUrl,
      cancelUrl: options.cancelUrl,
      mode: options.method.value,
    );

    return _client.post<AttachPaymentMethodToSubscriptionResponse>(
      path: '${_clientBasePath}subscriptions/attach/payment_method',
      data: request.toJson(),
      parser: (data) => AttachPaymentMethodToSubscriptionResponse.fromJson(
        data as Map<String, dynamic>,
      ),
    );
  }

  Future<ChangeSubscriptionPlanResponse> changeSubscriptionPlan({
    required RevenipeCustomer customer,
    required String newProductId,
    String? fromProductId,
  }) async {
    final subscription = resolveSubscriptionForPlanChange(
      subscriptions: customer.subscriptions,
      fromProductId: fromProductId,
    );

    if (subscription.pendingChange != null) {
      throw StateError('This subscription already has a pending plan change.');
    }

    final request = _ChangeSubscriptionPlanRequest(
      clientId: customer.customerId,
      sourceId: subscription.accessSourceId,
      newProductId: newProductId,
    );

    return _client.post<ChangeSubscriptionPlanResponse>(
      path: '${_clientBasePath}subscription/change_plan',
      data: request.toJson(),
      parser: (data) =>
          ChangeSubscriptionPlanResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<CancelSubscriptionResponse> cancelSubscription({
    required RevenipeCustomer customer,
    String? productId,
    SubscriptionCancelMode cancelMode = SubscriptionCancelMode.periodEnd,
  }) async {
    final subscription = resolveSubscriptionForCancel(
      subscriptions: customer.subscriptions,
      productId: productId,
    );

    final request = _CancelSubscriptionRequest(
      clientId: customer.customerId,
      sourceId: subscription.accessSourceId,
      cancelMode: cancelMode,
    );

    return _client.post<CancelSubscriptionResponse>(
      path: '${_clientBasePath}subscription/cancel',
      data: request.toJson(),
      parser: (data) =>
          CancelSubscriptionResponse.fromJson(data as Map<String, dynamic>),
    );
  }
}

class _AttachPaymentMethodToSubscriptionPlanRequest {
  final String clientId;
  final String sourceId;
  final String mode;
  final String? successUrl;
  final String? cancelUrl;

  const _AttachPaymentMethodToSubscriptionPlanRequest({
    required this.clientId,
    required this.sourceId,
    required this.mode,
    this.cancelUrl,
    this.successUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'access_source_id': sourceId,
      'mode': mode,
      'success_url': successUrl,
      'cancel_url': cancelUrl,
      'client_id': clientId,
    };
  }
}

class _ChangeSubscriptionPlanRequest {
  final String clientId;
  final String sourceId;
  final String newProductId;

  const _ChangeSubscriptionPlanRequest({
    required this.clientId,
    required this.sourceId,
    required this.newProductId,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'source_id': sourceId,
      'new_product_id': newProductId,
    };
  }
}

class _CancelSubscriptionRequest {
  final String clientId;
  final String sourceId;
  final SubscriptionCancelMode cancelMode;

  const _CancelSubscriptionRequest({
    required this.clientId,
    required this.sourceId,
    this.cancelMode = SubscriptionCancelMode.periodEnd,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'source_id': sourceId,
      'cancel_mode': cancelMode.value,
    };
  }
}
