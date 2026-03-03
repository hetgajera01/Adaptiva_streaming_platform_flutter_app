import 'package:cloud_firestore/cloud_firestore.dart';

class WatchHistory {
  final String videoId;
  final String watchedAt;
  final double progress; // 0–100

  WatchHistory({
    required this.videoId,
    required this.watchedAt,
    this.progress = 0.0,
  });

  /// Create WatchHistory from Firestore document data (handles Timestamp or String)
  factory WatchHistory.fromJson(Map<String, dynamic> json) {
    String watchedAtStr;
    final raw = json['watchedAt'];
    if (raw is Timestamp) {
      watchedAtStr = raw.toDate().toIso8601String();
    } else {
      watchedAtStr = (raw as String?) ?? '';
    }

    return WatchHistory(
      videoId: json['videoId'] as String,
      watchedAt: watchedAtStr,
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
