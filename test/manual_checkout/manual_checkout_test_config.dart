// -----------------------------------------------------------------------------
// Revenipe manual Checkout test configuration
// -----------------------------------------------------------------------------
// Paste your own IDs below.
//
// Identity vs. customer/client ID:
// - [loginIdentityFor] is the external identity used only for revenipe.login(...).
// - After login, Revenipe returns its internal client ID in the active session.
// - All purchase requests in these scripts use revenipe.currentCustomerId,
//   never the external login identity.

const String baseUrl = 'https://staging.revenipe.com/';
const String appKey = 'app_sandbox_6a18a8b24c6877c0d4a784975fdf257b51c768d246e22f1979160bc6ed821c92348a81c2'; // Paste sandbox app key.

// Increase this for a clean customer set when repeating all flows.
const String runId = 'run_001';
const String identityPrefix = 'checkout_flow_test';

String loginIdentityFor(String flow) => '${identityPrefix}_${runId}_$flow';

// Product IDs
const String normalSubscriptionProductId = 'normal_sub'; // Basic paid subscription.
const String upgradeSubscriptionProductId = 'upgrade_sub'; // Pro paid subscription.
const String directTrialProductId = 'trial_sub'; // Recurring product with direct trial enabled.
const String setupTrialProductId = 'trial_sub'; // Recurring product with setup-intent trial enabled.
const String oneOffProductId = 'one_off_purchase'; // Standalone one-off product.

// Tracking
const String trackingAccessProductId = 'normal_sub'; // Product granting the target entitlement/key.
const String trackingEntitlementOrUsageKeyId = 'track_renewable';
const int trackingAmount = 8;

// Checkout browser redirects
const String successUrl = 'https://revenipe.com/checkout-test/success';
const String cancelUrl = 'https://revenipe.com/checkout-test/cancel';

// Manual waiting after you complete Checkout / Stripe processing.
const bool openCheckoutInBrowser = true;
const int checkoutWaitSeconds = 45;
const int webhookRefreshWaitSeconds = 8;
