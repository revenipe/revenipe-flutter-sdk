class CustomerEntitlement {
  final String entitlementId;
  final String accessSourceId;
  final String type;
  final int remaining;
  final DateTime? expiresAt;

  const CustomerEntitlement({
    required this.entitlementId,
    required this.accessSourceId,
    required this.type,
    required this.remaining,
    required this.expiresAt,
  });

  factory CustomerEntitlement.fromJson(Map<String, dynamic> json) {
    return CustomerEntitlement(
      entitlementId: json['entitlement_id'] as String? ?? '',
      accessSourceId: json['access_source_id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      remaining: json['remaining'] as int? ?? 0,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null,
    );
  }

  CustomerEntitlement copyWith({
    String? entitlementId,
    String? accessSourceId,
    String? type,
    int? remaining,
    DateTime? expiresAt,
  }) {
    return CustomerEntitlement(
      entitlementId: entitlementId ?? this.entitlementId,
      accessSourceId: accessSourceId ?? this.accessSourceId,
      type: type ?? this.type,
      remaining: remaining ?? this.remaining,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}