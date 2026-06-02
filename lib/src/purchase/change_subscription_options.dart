class ChangeSubscriptionPlanOptions {
  final String clientId;
  final String sourceId;
  final String newProductId;

  const ChangeSubscriptionPlanOptions({
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
