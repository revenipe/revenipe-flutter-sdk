class ProductEntitlement {
  final String entitlementId;
  final String name;
  final String description;

  ProductEntitlement({
    required this.entitlementId,
    required this.name,
    required this.description,
  });

  factory ProductEntitlement.fromJson(Map<String, dynamic> json) {
    return ProductEntitlement(
      entitlementId: json['entitlement_id'],
      name: json['name'],
      description: json['description'],
    );
  }
}