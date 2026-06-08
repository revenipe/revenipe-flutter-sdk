class CancelAddOnResponse {
  final bool success;
  final String sourceId;
  final String status;
  final String? message;

  const CancelAddOnResponse({
    required this.success,
    required this.sourceId,
    required this.status,
    this.message,
  });

  factory CancelAddOnResponse.fromJson(Map<String, dynamic> json) {
    return CancelAddOnResponse(
      success: json['success'] as bool? ?? false,
      sourceId: json['source_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'source_id': sourceId,
      'status': status,
      if (message != null) 'message': message,
    };
  }
}
