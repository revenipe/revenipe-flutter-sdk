import 'package:revenipe_flutter/src/models/product.dart';

class AppProductsResponse {
  final List<Product> products;

  AppProductsResponse({required this.products});

  factory AppProductsResponse.fromJson(Map<String, dynamic> json) {
    return AppProductsResponse(
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e))
              .toList() ??
          [],
    );
  }
}
