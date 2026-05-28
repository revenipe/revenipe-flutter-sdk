import 'package:revenipe_flutter/src/core/respponses/app_products_response.dart';
import 'package:revenipe_flutter/src/core/respponses/cancel_add_on_response.dart';
import 'package:revenipe_flutter/src/core/respponses/cancel_subscription_response.dart';
import 'package:revenipe_flutter/src/core/respponses/change_subscription_response.dart';
import 'package:revenipe_flutter/src/core/respponses/start_purchase_response.dart';
import 'package:revenipe_flutter/src/core/respponses/track_respopnse.dart';
import 'package:revenipe_flutter/src/core/utils/anonym_id.dart';
import 'package:revenipe_flutter/src/core/utils/session_updates.dart';
import 'package:revenipe_flutter/src/models/models.dart';
import 'package:revenipe_flutter/src/purchase/purchase_options.dart';
import 'package:revenipe_flutter/src/purchase/subscription_cancel_mode.dart';
import 'package:revenipe_flutter/src/services/app_service.dart';
import 'package:revenipe_flutter/src/services/customer_service.dart';
import 'package:revenipe_flutter/src/services/purchase_service.dart';

import '../exceptions/revenipe_exception.dart';
import '../network/revenipe_http_client.dart';
import '../services/auth_service.dart';
import 'revenipe_config.dart';
import 'revenipe_session.dart';

class Revenipe {
  Revenipe._();

  static final Revenipe instance = Revenipe._();

  RevenipeConfig? _config;
  RevenipeHttpClient? _httpClient;
  AuthService? _authService;
  CustomerService? _customerService;
  AppService? _appService;
  PurchaseService? _purchaseService;
  RevenipeSession? _session;

  bool get isInitialized => _config != null;
  bool get isIdentified => _session != null;
  RevenipeConfig? get config => _config;
  RevenipeSession? get session => _session;
  String? get appId => _config?.appId;
  String? get currentCustomerId => _session?.customerId;
  RevenipeCustomer? get customer => _session?.customer;


  /// Cancels an active or trialing subscription for the current customer.
  ///
  /// By default, the subscription is canceled at the end of the current billing
  /// period or trial period. The customer keeps access until that date.
  ///
  /// Set [cancelMode] to [SubscriptionCancelMode.immediately] to cancel the
  /// subscription right away.
  ///
  /// If the customer has one active or trialing subscription, it is selected
  /// automatically. If the customer has multiple active or trialing subscriptions,
  /// pass [productId] to choose which subscription to cancel.
  ///
  /// After calling this method, refresh the customer to get the updated
  /// cancellation state. Revenipe updates access from Stripe webhooks.
  ///
  /// Example:
  /// ```dart
  /// await Revenipe.instance.cancelSubscription(
  ///   customer: customer,
  /// );
  /// ```
  ///
  /// Example with a specific product:
  /// ```dart
  /// await Revenipe.instance.cancelSubscription(
  ///   customer: customer,
  ///   productId: 'pro_monthly',
  /// );
  /// ```
  ///
  /// Example with immediate cancellation:
  /// ```dart
  /// await Revenipe.instance.cancelSubscription(
  ///   customer: customer,
  ///   productId: 'pro_monthly',
  ///   cancelMode: SubscriptionCancelMode.immediately,
  /// );
  /// ```
  Future<CancelSubscriptionResponse> cancelSubscription({
    String? productId,
    SubscriptionCancelMode cancelMode = SubscriptionCancelMode.periodEnd,
  }) async {
    final purchaseService = _requirePurchaseService();

    final cus = _requireCustomer();

    final response = await purchaseService.cancelSubscription(
      customer: cus,
      productId: productId,
      cancelMode: cancelMode,
    );

    return response;
  }

  /// Changes the customer's active subscription to another recurring product.
  ///
  /// The SDK resolves the correct subscription access source automatically from
  /// [customer.subscriptions], so you usually only need to pass [newProductId].
  ///
  /// If the customer has exactly one active or trialing subscription, that
  /// subscription is used automatically.
  ///
  /// If the customer has multiple active or trialing subscriptions, pass
  /// [fromProductId] to tell Revenipe which current subscription should be
  /// changed.
  ///
  /// Depending on the plan change type, Revenipe may apply the change immediately
  /// or schedule it for the end of the current billing period:
  ///
  /// - upgrades and longer billing intervals are usually processed immediately
  /// - downgrades and shorter billing intervals are usually scheduled
  ///
  /// Access is updated after Stripe confirms the billing change through webhooks,
  /// so you should refresh the customer after calling this method.
  ///
  /// Example:
  /// ```dart
  /// await Revenipe.instance.changeSubscription(
  ///   customer: customer,
  ///   newProductId: 'pro_monthly',
  /// );
  /// ```
  ///
  /// Example with multiple subscriptions:
  /// ```dart
  /// await Revenipe.instance.changeSubscription(
  ///   customer: customer,
  ///   fromProductId: 'basic_monthly',
  ///   newProductId: 'pro_monthly',
  /// );
  /// ```
  Future<ChangeSubscriptionPlanResponse> changeSubscription({
    required String newProductId,
    String? fromProductId,
  }) async {
    final purchaseService = _requirePurchaseService();
    final cus = _requireCustomer();
    final response = await purchaseService.changeSubscriptionPlan(
      customer: cus,
      newProductId: newProductId,
      fromProductId: fromProductId,
    );
    return response;
  }

  /// Starts a purchase flow for a Revenipe product.
  ///
  /// This can start different Stripe-backed purchase flows depending on the
  /// product and the provided [options], for example:
  ///
  /// - Checkout
  /// - PaymentSheet
  /// - one-off purchases
  /// - subscriptions
  /// - direct trials without payment collection
  /// - SetupIntent trials where a payment method is collected first
  ///
  /// The returned [StartPurchaseResponse] tells the SDK/client which flow was
  /// started and contains the data needed to continue the purchase, such as a
  /// Checkout URL, PaymentSheet data, SetupIntent data, or subscription state.
  ///
  /// For direct trials, no Stripe UI may be required. For Checkout or
  /// PaymentSheet flows, the SDK/service will use the returned response data to
  /// continue the purchase flow.
  ///
  /// After a successful purchase, you should refresh the customer because access
  /// and entitlements are finalized by Revenipe webhooks.
  ///
  /// Example:
  /// ```dart
  /// await Revenipe.instance.startPurchase(
  ///   options: MakePurchaseOptions(
  ///     productId: 'pro_monthly',
  ///     purchaseMethod: PurchaseMethod.paymentSheet,
  ///   ),
  /// );
  /// ```
  Future<StartPurchaseResponse> startPurchase({
    required MakePurchaseOptions options,
  }) async {
    final purchaseService = _requirePurchaseService();
    final response = await purchaseService.startPurchase(options);
    return response;
  }

  /// Retrieves the products configured for the current app.
  ///
  /// This method fetches all products defined in the Revenipe dashboard for the
  /// configured application. These products represent the offerings available
  /// to end users, such as subscriptions, one-time purchases, or add-ons.
  ///
  /// On a successful response, the retrieved products are stored in the current
  /// session and can be accessed locally without additional network requests.
  ///
  /// ## Returns
  /// An [AppProductsResponse] containing the list of configured products.
  ///
  /// ## Throws
  /// - [RevenipeException] if the request fails or the SDK is not properly configured.
  ///
  /// ## Notes
  /// - This method performs a network request to fetch the latest product configuration.
  /// - Products are defined by the developer in the Revenipe dashboard and are
  ///   not customer-specific.
  /// - Calling this method will update the local session with the latest products.
  /// - If no products are configured, the session will remain unchanged.
  ///
  /// ## Example
  /// ```dart
  /// final response = await revenipe.getProducts();
  ///
  /// for (final product in response.products) {
  ///   print(product.name);
  /// }
  /// ```
  Future<AppProductsResponse> getProducts() async {
    final appService = _requireAppService();
    final result = await appService.getProducts();

    if (result.products.isNotEmpty) {
      _session = _session!.copyWith(products: result.products);
    }

    return result;
  }

  /// Configures the Revenipe SDK and prepares it for use.
  ///
  /// This method must be called before invoking any customer, entitlement,
  /// or usage-related operations. It initializes the internal HTTP client
  /// and required service layers using the provided [config].
  ///
  /// Calling this method also resets the current in-memory session. Any
  /// previously identified customer will be cleared and must be re-authenticated.
  ///
  /// ## Parameters
  /// - [config]: The SDK configuration used to initialize Revenipe, including
  ///   values such as the app ID and backend base URL.
  ///
  /// ## Throws
  /// - [RevenipeException] if the SDK cannot be initialized properly.
  ///
  /// ## Notes
  /// - This method should typically be called once during app startup.
  /// - Reconfiguring the SDK will clear the current session.
  ///
  /// ## Example
  /// ```dart
  /// await revenipe.configure(
  ///   config: const RevenipeConfig(
  ///     appId: 'app_123',
  ///   ),
  /// );
  /// ```
  Future<void> configure({required RevenipeConfig config}) async {
    _config = config;
    _httpClient = RevenipeHttpClient(config: config);
    _authService = AuthService(_httpClient!);
    _customerService = CustomerService(_httpClient!);
    _appService = AppService(_httpClient!);
    _purchaseService = PurchaseService(_httpClient!);
    _session = null;
  }

  /// Identifies or creates a customer session for the given [customerId].
  ///
  /// This method establishes the active session within the SDK. If a customer
  /// with the provided [customerId] already exists, it will be loaded. Otherwise,
  /// a new customer will be created automatically on the backend.
  ///
  /// The returned [RevenipeCustomer] represents the current server state,
  /// including entitlements, usage keys, subscriptions, and add-ons.
  ///
  /// The session is stored internally and used for all subsequent SDK operations
  /// such as entitlement checks, usage tracking, and data refresh.
  ///
  /// ## Parameters
  /// - [customerId]: A unique identifier for the customer. This should be:
  ///   - Stable across app launches
  ///   - Unique per user/device
  ///   - Non-empty
  ///
  /// ## Returns
  /// A fully initialized [RevenipeCustomer] object reflecting the current state.
  ///
  /// ## Throws
  /// - [RevenipeException] if the request fails or the SDK is not properly configured.
  ///
  /// ## Example
  /// ```dart
  /// final customer = await revenipe.login('user_123');
  /// print(customer.customerId);
  /// ```
  Future<RevenipeCustomer> login(String customerId) async {
    final authService = _requireAuthService();
    final user = await authService.loginCustomer(customerId);
    _session = RevenipeSession(
      customer: user,
      identifiedAt: DateTime.now().toUtc(),
      products: [],
    );
    return user;
  }

  /// Creates and identifies an anonymous customer session.
  ///
  /// This method generates a new unique customer identifier internally and
  /// initializes a session using that identifier. If the generated identifier
  /// does not exist on the backend, a new customer will be created automatically.
  ///
  /// Anonymous sessions are typically used for users who have not explicitly
  /// signed in. The generated customer ID is not persisted by default, meaning
  /// a new anonymous customer may be created on each app launch unless you store
  /// and reuse the identifier externally.
  ///
  /// The returned [RevenipeCustomer] contains the current server state,
  /// including entitlements, usage keys, subscriptions, and add-ons.
  ///
  /// ## Returns
  /// A fully initialized [RevenipeCustomer] representing the anonymous customer.
  ///
  /// ## Throws
  /// - [RevenipeException] if the request fails or the SDK is not properly configured.
  ///
  /// ## Notes
  /// - Consider persisting the generated customer ID if you want to maintain
  ///   a consistent anonymous user across sessions.
  /// - You can later upgrade this anonymous user to an identified user by
  ///   calling [login] with a stable identifier.
  ///
  /// ## Example
  /// ```dart
  /// final customer = await revenipe.anonymLogin();
  /// print(customer.customerId);
  /// ```
  Future<RevenipeCustomer> anonymLogin() async {
    final authService = _requireAuthService();
    var customerId = AnonymousId.generate();
    final user = await authService.loginCustomer(customerId);
    _session = RevenipeSession(
      customer: user,
      identifiedAt: DateTime.now().toUtc(),
      products: [],
    );
    return user;
  }

  /// Tracks usage for an entitlement or usage key and updates the local session.
  ///
  /// This method sends a usage tracking request to the backend for the given [id]
  /// and [value]. The [id] can represent either:
  /// - an entitlement ID
  /// - a usage key ID
  ///
  /// On successful tracking, the SDK updates the internal session state:
  /// - If [id] refers to an entitlement → its `remaining` value is updated
  /// - If [id] refers to a usage key → its aggregated `remaining` value is updated
  ///
  /// The update is performed immutably, ensuring consistent local state for
  /// subsequent reads (e.g. entitlement checks or UI updates).
  ///
  /// ## Parameters
  /// - [id]: The entitlement ID or usage key ID to track usage for
  /// - [value]: The amount of usage to consume (must be > 0)
  ///
  /// ## Returns
  /// A [TrackEntitlementResponse] containing the result of the operation,
  /// including updated remaining values from the backend.
  ///
  /// ## Throws
  /// - [RevenipeException] if:
  ///   - the SDK is not initialized or no session exists
  ///   - the network request fails
  ///
  /// ## Notes
  /// - The backend is considered the source of truth. Local state is updated
  ///   only after a successful response.
  ///
  /// ## Example
  /// ```dart
  /// final result = await revenipe.track('credits', 1);
  ///
  /// if (result.success) {
  ///   print('Remaining: ${result.remaining}');
  /// }
  /// ```
  Future<TrackEntitlementResponse> track(String id, int value) async {
    if (value <= 0) {
      throw RevenipeOperationException(message: 'Value must be greater than 0');
    }
    final usageService = _requireCustomerService();
    final result = await usageService.track(_session!, id, value);

    var hasKey = _hasUsageKey(id);

    if (result.success && !hasKey) {
      _session = _session!.updateEntitlementRemaining(
        entitlementId: result.entitlementId,
        newRemaining: result.remaining,
      );
    } else if (result.success && hasKey) {
      _session = _session!.updateUsageKeyRemaining(
        usageKeyId: result.entitlementId,
        newRemaining: result.remaining,
      );
    }

    return result;
  }

  /// Retrieves a usage key by its identifier from the current session.
  ///
  /// This method returns the [UsageKey] associated with the given [keyId]
  /// from the currently identified customer session. If no matching usage key
  /// is found, `null` is returned.
  ///
  /// ## Parameters
  /// - [keyId]: The unique identifier of the usage key.
  ///
  /// ## Returns
  /// The matching [UsageKey] if found, otherwise `null`.
  ///
  /// ## Throws
  /// - [RevenipeConfigurationException] if the SDK is not configured or no
  ///   customer session is active.
  ///
  /// ## Notes
  /// - This method only reads from the local session state and does not perform
  ///   any network request.
  /// - Ensure that a customer has been identified (via [login] or [anonymLogin])
  ///   before calling this method.
  ///
  /// ## Example
  /// ```dart
  /// final usageKey = revenipe.getUsageKey('credits');
  ///
  /// if (usageKey != null) {
  ///   print('Remaining: ${usageKey.remaining}');
  /// }
  /// ```
  UsageKey? getUsageKey(String keyId) {
    if (!isIdentified) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    var keys = session!.customer.usageKeys;

    var result = keys.where((item) => item.usageKeyId == keyId);

    return result.isNotEmpty ? result.first : null;
  }

  /// Retrieves an entitlement by its identifier from the current session.
  ///
  /// This method returns the first [CustomerEntitlement] that matches the given
  /// [entitlementId] from the currently identified customer session. If no
  /// matching entitlement is found, `null` is returned.
  ///
  /// ## Parameters
  /// - [entitlementId]: The unique identifier of the entitlement.
  ///
  /// ## Returns
  /// The matching [CustomerEntitlement] if found, otherwise `null`.
  ///
  /// ## Throws
  /// - [RevenipeConfigurationException] if the SDK is not configured or no
  ///   customer session is active.
  ///
  /// ## Notes
  /// - This method only reads from the local session state and does not perform
  ///   any network request.
  /// - If multiple entitlements share the same [entitlementId] (e.g. from different
  ///   access sources), only the first match is returned.
  /// - For aggregated or multi-source scenarios, consider using usage keys instead.
  ///
  /// ## Example
  /// ```dart
  /// final entitlement = revenipe.getEntitlement('credits');
  ///
  /// if (entitlement != null) {
  ///   print('Remaining: ${entitlement.remaining}');
  /// }
  /// ```
  CustomerEntitlement? getEntitlement(String entitlementId) {
    if (!isIdentified) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    var entitlements = session!.customer.entitlements;

    var result = entitlements.where(
      (item) => item.entitlementId == entitlementId,
    );

    return result.isNotEmpty ? result.first : null;
  }

  /// Retrieves a subscription by its associated product ID from the current session.
  ///
  /// This method returns the first [CustomerSubscription] that matches the given
  /// [productId] from the currently identified customer session. If no matching
  /// subscription is found, `null` is returned.
  ///
  /// ## Parameters
  /// - [productId]: The product identifier associated with the subscription.
  ///
  /// ## Returns
  /// The matching [CustomerSubscription] if found, otherwise `null`.
  ///
  /// ## Throws
  /// - [RevenipeConfigurationException] if the SDK is not configured or no
  ///   customer session is active.
  ///
  /// ## Notes
  /// - This method only reads from the local session state and does not perform
  ///   any network request.
  /// - If multiple subscriptions exist for the same [productId], only the first
  ///   match is returned.
  /// - Subscription state (active, expired, trial, etc.) should be evaluated
  ///   on the returned object if needed.
  ///
  /// ## Example
  /// ```dart
  /// final subscription = revenipe.getSubscription('pro_plan');
  ///
  /// if (subscription != null) {
  ///   print('Subscription active: ${subscription.isActive}');
  /// }
  /// ```
  CustomerSubscription? getSubscription(String productId) {
    if (!isIdentified) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    var subscriptions = session!.customer.subscriptions;

    var result = subscriptions.where((item) => item.productId == productId);

    return result.isNotEmpty ? result.first : null;
  }

  /// Checks whether the current customer has a subscription for the given product.
  ///
  /// This method returns `true` if at least one [CustomerSubscription] exists
  /// for the provided [productId] in the current session, otherwise `false`.
  ///
  /// ## Parameters
  /// - [productId]: The product identifier associated with the subscription.
  ///
  /// ## Returns
  /// `true` if a matching subscription exists, otherwise `false`.
  ///
  /// ## Throws
  /// - [RevenipeConfigurationException] if the SDK is not configured or no
  ///   customer session is active.
  ///
  /// ## Notes
  /// - This method only checks for existence in the local session and does not
  ///   perform any network request.
  /// - It does not evaluate subscription state (e.g. active, expired, canceled).
  ///   You should inspect the returned [CustomerSubscription] via [getSubscription]
  ///   if you need detailed status information.
  /// - If multiple subscriptions exist for the same product, only existence is checked.
  ///
  /// ## Example
  /// ```dart
  /// final hasPro = revenipe.hasSubscription('pro_plan');
  ///
  /// if (hasPro) {
  ///   print('User has Pro subscription');
  /// }
  /// ```
  bool hasSubscription(String productId) {
    if (!isIdentified) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    var subscriptions = session!.customer.subscriptions;

    return subscriptions
        .where((item) => item.productId == productId)
        .isNotEmpty;
  }

  bool _hasUsageKey(String keyId) {
    if (!isIdentified) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    var keys = session!.customer.usageKeys;

    return keys.where((item) => item.usageKeyId == keyId).isNotEmpty;
  }

  /// Checks whether the current customer has access to a given entitlement.
  ///
  /// This method returns `true` if at least one [CustomerEntitlement] exists
  /// for the provided [entitlementId] in the current session, otherwise `false`.
  ///
  /// ## Parameters
  /// - [entitlementId]: The identifier of the entitlement to check.
  ///
  /// ## Returns
  /// `true` if the entitlement exists for the current customer, otherwise `false`.
  ///
  /// ## Throws
  /// - [RevenipeConfigurationException] if the SDK is not configured or no
  ///   customer session is active.
  ///
  /// ## Notes
  /// - This method only checks for existence in the local session and does not
  ///   perform any network request.
  /// - If multiple entitlements exist for the same [entitlementId] (e.g. from
  ///   different access sources), this method returns `true` if at least one exists.
  /// - This method does not validate remaining usage or expiration. To check
  ///   usable access, you may need to inspect the entitlement's `remaining`
  ///   and `expiresAt` values.
  ///
  /// ## Example
  /// ```dart
  /// final hasAccess = revenipe.hasEntitlement('credits');
  ///
  /// if (hasAccess) {
  ///   print('User has access to credits');
  /// }
  /// ```
  bool hasEntitlement(String entitlementId) {
    if (!isIdentified) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    var entitlements = session!.customer.entitlements;

    return entitlements
        .where((item) => item.entitlementId == entitlementId)
        .isNotEmpty;
  }

  AuthService _requireAuthService() {
    if (!isInitialized || _authService == null) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    return _authService!;
  }

  CustomerService _requireCustomerService() {
    if (!isInitialized || _customerService == null) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    return _customerService!;
  }

  AppService _requireAppService() {
    if (!isInitialized || _appService == null) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    return _appService!;
  }

  PurchaseService _requirePurchaseService() {
    if (!isInitialized || _purchaseService == null) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured. Call Revenipe.instance.configure(...) first.',
      );
    }

    return _purchaseService!;
  }

  RevenipeCustomer _requireCustomer() {
    if (!isInitialized || customer == null) {
      throw const RevenipeConfigurationException(
        'Revenipe is not configured or the user is not logged in. Call Revenipe.instance.configure(...) / evenipe.instance.login(...) first.',
      );
    }

    return customer!;
  }

  /// Clears the current customer session.
  ///
  /// This method removes the active session from the SDK, effectively logging
  /// out the current customer. After calling this method, the SDK will no longer
  /// have access to any customer-related data such as entitlements, usage keys,
  /// subscriptions, or add-ons.
  ///
  /// Any subsequent calls that require an identified customer (e.g. entitlement
  /// checks or usage tracking) will throw a [RevenipeConfigurationException]
  /// until a new session is established via [login] or [anonymLogin].
  ///
  /// ## Notes
  /// - This method only clears the in-memory session and does not perform any
  ///   network request.
  /// - If you are using a persisted anonymous or user identifier, you may also
  ///   want to clear it separately depending on your app's logout behavior.
  ///
  /// ## Example
  /// ```dart
  /// revenipe.clearSession();
  /// ```
  void clearSession() {
    _session = null;
  }
}
