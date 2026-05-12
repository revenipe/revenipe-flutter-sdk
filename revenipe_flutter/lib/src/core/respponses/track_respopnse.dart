class TrackEntitlementResponse {
  final bool success;
  final int requested;
  final int consumed;
  final int remaining;
  final String entitlementId;
  final String? accessSourceId;
  final String? error;

  TrackEntitlementResponse({
    required this.success,
    required this.requested,
    required this.consumed,
    required this.remaining,
    required this.entitlementId,
    this.accessSourceId,
    this.error,
  });

  factory TrackEntitlementResponse.fromJson(Map<String, dynamic> json) {
    return TrackEntitlementResponse(
      success: json['success'] as bool,
      requested: json['requested'] as int,
      consumed: json['consumed'] as int,
      remaining: json['remaining'] as int,
      entitlementId: json['entitlement_id'] as String,
      accessSourceId: json['access_source_id'] as String?,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'requested': requested,
      'consumed': consumed,
      'remaining': remaining,
      'entitlement_id': entitlementId,
      'access_source_id': accessSourceId,
      'error': error,
    };
  }
}