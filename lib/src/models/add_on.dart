class CustomerAddOn {
  final String accessSourceId;
  final String productId;
  final String productName;
  final String status;
  final String billingType;
  final DateTime? expiresAt;
  final DateTime? renewsAt;
  final bool canCancel;

  const CustomerAddOn({
    required this.accessSourceId,
    required this.productId,
    required this.productName,
    required this.status,
    required this.billingType,
    required this.expiresAt,
    required this.renewsAt,
    required this.canCancel,
  });

  factory CustomerAddOn.fromJson(Map<String, dynamic> json) {
    return CustomerAddOn(
      accessSourceId: json['access_source_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      billingType: json['billing_type'] as String? ?? '',
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null,
      renewsAt: json['renews_at'] != null
          ? DateTime.tryParse(json['renews_at'] as String)
          : null,
      canCancel: json['can_cancel'] as bool? ?? false,
    );
  }

  CustomerAddOn copyWith({
    String? accessSourceId,
    String? productId,
    String? productName,
    String? status,
    String? billingType,
    DateTime? expiresAt,
    DateTime? renewsAt,
    bool? canCancel,
  }) {
    return CustomerAddOn(
      accessSourceId: accessSourceId ?? this.accessSourceId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      status: status ?? this.status,
      billingType: billingType ?? this.billingType,
      expiresAt: expiresAt ?? this.expiresAt,
      renewsAt: renewsAt ?? this.renewsAt,
      canCancel: canCancel ?? this.canCancel,
    );
  }
}
