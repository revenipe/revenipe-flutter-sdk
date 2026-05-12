import 'package:revenipe_flutter/src/models/models.dart';

class RevenipeSession {
  final RevenipeCustomer customer;
  final DateTime identifiedAt;
  final List<Product> products;

  const RevenipeSession({required this.customer, required this.identifiedAt, required this.products});

  String get customerId => customer.customerId;

  RevenipeSession copyWith({
    RevenipeCustomer? customer,
    DateTime? identifiedAt,
    List<Product>? products

  }) {
    return RevenipeSession(
      products: products ?? this.products,
      customer: customer ?? this.customer,
      identifiedAt: identifiedAt ?? this.identifiedAt,
    );
  }
}
