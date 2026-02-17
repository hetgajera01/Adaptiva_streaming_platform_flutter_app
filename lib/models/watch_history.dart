class WatchHistory {
  final String videoId;
  final String watchedAt;
  final double progress; // 0-100

  WatchHistory({
    required this.videoId,
    required this.watchedAt,
    this.progress = 0.0,
  });

  /// Create WatchHistory from JSON
  factory WatchHistory.fromJson(Map<String, dynamic> json) {
    return WatchHistory(
      videoId: json['videoId'] as String,
      watchedAt: json['watchedAt'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert WatchHistory to JSON
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'watchedAt': watchedAt,
      'progress': progress,
    };
  }
}
