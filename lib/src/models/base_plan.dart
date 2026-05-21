class CustomerBasePlan {
  final String sourceId;
  final String status;
  final String? productId;
  final String? productName;
  final String interval;
  final DateTime? periodEnd;

  const CustomerBasePlan({
    required this.sourceId,
    required this.status,
    required this.interval,
    this.productId,
    this.productName,
    this.periodEnd,
  });

  factory CustomerBasePlan.fromJson(Map<String, dynamic> json) {
    return CustomerBasePlan(
      sourceId: json['source_id'] as String,
      status: json['status'] as String,
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String?,
      interval: json['interval'] as String,
      periodEnd: json['period_end'] == null
          ? null
          : DateTime.parse(json['period_end'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source_id': sourceId,
      'status': status,
      'product_id': productId,
      'product_name': productName,
      'interval': interval,
      'period_end': periodEnd?.toIso8601String(),
    };
  }

  CustomerBasePlan copyWith({
    String? sourceId,
    String? status,
    String? productId,
    String? productName,
    String? interval,
    DateTime? periodEnd,
  }) {
    return CustomerBasePlan(
      sourceId: sourceId ?? this.sourceId,
      status: status ?? this.status,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      interval: interval ?? this.interval,
      periodEnd: periodEnd ?? this.periodEnd,
    );
  }
}