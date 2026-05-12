import 'package:revenipe_flutter/src/models/product_entitlement.dart';

class Product {
  final String productId;
  final String name;
  final String description;
  final int? price;
  final String type;
  final String? recurringInterval;
  final String? appStoreProductId;
  final String? playStoreProductId;
  final List<ProductEntitlement> entitlements;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.type,
    required this.entitlements,
    this.price,
    this.recurringInterval,
    this.appStoreProductId,
    this.playStoreProductId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      type: json['type'],
      recurringInterval: json['recurring_interval'],
      appStoreProductId: json['app_store_product_id'],
      playStoreProductId: json['play_store_product_id'],
      entitlements: (json['entitlements'] as List<dynamic>?)
              ?.map((e) => ProductEntitlement.fromJson(e))
              .toList() ??
          [],
    );
  }
}