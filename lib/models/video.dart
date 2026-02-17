class Video {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String thumbnailUrl;
  final String videoUrl;
  final int duration; // in seconds
  final String createdAt;
  final bool featured;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.createdAt,
    this.featured = false,
  });

  /// Create Video from JSON
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      duration: json['duration'] as int,
      createdAt: json['createdAt'] as String,
      featured: json['featured'] as bool? ?? false,
    );
  }

  /// Convert Video to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'duration': duration,
      'createdAt': createdAt,
      'featured': featured,
    };
  }

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
