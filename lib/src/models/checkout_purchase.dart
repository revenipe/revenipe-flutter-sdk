class CheckoutPurchase {
  final String sessionId;
  final String checkoutUrl;

  const CheckoutPurchase({required this.sessionId, required this.checkoutUrl});

  factory CheckoutPurchase.fromJson(Map<String, dynamic> json) {
    return CheckoutPurchase(
      sessionId: json['session_id'] as String,
      checkoutUrl: json['checkout_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'session_id': sessionId, 'checkout_url': checkoutUrl};
  }
}
