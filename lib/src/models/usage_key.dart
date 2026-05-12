class UsageKey {
  final String usageKeyId;
  final String name;
  final int remaining;

  const UsageKey({
    required this.usageKeyId,
    required this.name,
    required this.remaining,
  });

  factory UsageKey.fromJson(Map<String, dynamic> json) {
    return UsageKey(
      usageKeyId: json['usage_key_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      remaining: json['remaining'] as int? ?? 0,
    );
  }


  UsageKey copyWith({
    String? usageKeyId,
    String? name,
    int? remaining,
  }) {
    return UsageKey(
      usageKeyId: usageKeyId ?? this.usageKeyId,
      name: name ?? this.name,
      remaining: remaining ?? this.remaining,
    );
  }
}