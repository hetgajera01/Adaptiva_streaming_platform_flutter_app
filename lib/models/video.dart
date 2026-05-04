import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String thumbnailUrl;
  final String videoUrl;
  final String? hlsUrl; // HLS master playlist URL (e.g., CloudFront .m3u8)
  final List<String> qualities; // Available qualities ["240p","480p","720p","1080p"]
  final int duration; // in seconds
  final String createdAt;
  final bool featured;
  final bool isActive;
  final int viewCount;
  final List<String> tags;
  final String? addedBy; // Admin UID who uploaded the video

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.hlsUrl,
    this.qualities = const [],
    required this.duration,
    required this.createdAt,
    this.featured = false,
    this.isActive = true,
    this.viewCount = 0,
    this.tags = const [],
    this.addedBy,
  });

  /// Create Video from Firestore document data (handles Timestamp or String)
  factory Video.fromJson(Map<String, dynamic> json) {
    // createdAt can be a Firestore Timestamp or an ISO string
    String createdAtStr;
    final raw = json['createdAt'];
    if (raw is Timestamp) {
      createdAtStr = raw.toDate().toIso8601String();
    } else {
      createdAtStr = (raw as String?) ?? '';
    }

    // tags can be List<dynamic> from Firestore
    final rawTags = json['tags'];
    final List<String> tagsList = rawTags != null
        ? List<String>.from(rawTags as List)
        : [];

    // qualities can be List<dynamic> from Firestore
    final rawQualities = json['qualities'];
    final List<String> qualitiesList = rawQualities != null
        ? List<String>.from(rawQualities as List)
        : [];

    return Video(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      hlsUrl: json['hlsUrl'] as String?,
      qualities: qualitiesList,
      duration: (json['duration'] as num).toInt(),
      createdAt: createdAtStr,
      featured: json['featured'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      tags: tagsList,
      addedBy: json['addedBy'] as String?,
    );
  }

  /// Convert Video to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      if (hlsUrl != null) 'hlsUrl': hlsUrl,
      'qualities': qualities,
      'duration': duration,
      'createdAt': createdAt,
      'featured': featured,
      'isActive': isActive,
      'viewCount': viewCount,
      'tags': tags,
      if (addedBy != null) 'addedBy': addedBy,
    };
  }

  /// Get the best playback URL — prefers HLS when available
  String get playbackUrl => (hlsUrl != null && hlsUrl!.isNotEmpty) ? hlsUrl! : videoUrl;

  /// Whether this video has an HLS stream
  bool get isHls => hlsUrl != null && hlsUrl!.isNotEmpty;

  /// Get formatted duration (e.g., "1h 30m")
  String getFormattedDuration() {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
