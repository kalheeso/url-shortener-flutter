class ShortenedUrl {
  final String originalUrl;
  final String shortUrl;
  final DateTime? createdAt;

  ShortenedUrl({
    required this.originalUrl,
    required this.shortUrl,
    this.createdAt,
  });

  factory ShortenedUrl.fromJson(Map<String, dynamic> json) {
    final links = json['_links'] as Map<String, dynamic>?;

    final shortUrl = links?['short'] as String? ?? links?['self'] as String?;

    final originalUrl = links?['self'] as String?;

    if (shortUrl == null || shortUrl.isEmpty) {
      throw Exception('Failed to parse shortened URL from response: missing _links.short or _links.self');
    }

    if (originalUrl == null || originalUrl.isEmpty) {
      throw Exception('Failed to parse original URL from response: missing _links.self');
    }

    return ShortenedUrl(
      originalUrl: originalUrl,
      shortUrl: shortUrl,
    );
  }

  ShortenedUrl copyWith({
    String? originalUrl,
    String? shortUrl,
    DateTime? createdAt,
  }) {
    return ShortenedUrl(
      originalUrl: originalUrl ?? this.originalUrl,
      shortUrl: shortUrl ?? this.shortUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
