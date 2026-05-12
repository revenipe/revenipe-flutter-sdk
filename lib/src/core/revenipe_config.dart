class RevenipeConfig {
  final String appId;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableLogging;
  final Map<String, String> defaultHeaders;

  const RevenipeConfig({
    required this.appId,
    this.baseUrl = 'https://api.revenipe.com/',
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.enableLogging = false,
    this.defaultHeaders = const {},
  });

  RevenipeConfig copyWith({
    String? appId,
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool? enableLogging,
    Map<String, String>? defaultHeaders,
  }) {
    return RevenipeConfig(
      appId: appId ?? this.appId,
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      enableLogging: enableLogging ?? this.enableLogging,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
    );
  }
}
