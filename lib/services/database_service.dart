import 'package:firebase_database/firebase_database.dart';
import 'package:mad_project/models/category.dart';
import 'package:mad_project/models/video.dart';
import 'package:mad_project/models/watch_history.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  
  factory DatabaseService() {
    return _instance;
  }
  
  DatabaseService._internal();
  
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  /// Get all categories ordered by order field
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _database.child('categories').get();
      
      if (!snapshot.exists) {
        return [];
      }
      
      final categoriesMap = Map<String, dynamic>.from(snapshot.value as Map);
      final categories = <Category>[];
      
      categoriesMap.forEach((key, value) {
        final categoryData = Map<String, dynamic>.from(value as Map);
        categories.add(Category.fromJson(categoryData));
      });
      
      // Sort by order
      categories.sort((a, b) => a.order.compareTo(b.order));
      
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
  
  /// Get all videos or filter by category/featured
  Future<List<Video>> getVideos({
    String? categoryId,
    bool? featured,
  }) async {
    try {
      final snapshot = await _database.child('videos').get();
      
      if (!snapshot.exists) {
        return [];
      }
      
      final videosMap = Map<String, dynamic>.from(snapshot.value as Map);
      final videos = <Video>[];
      
      videosMap.forEach((key, value) {
        final videoData = Map<String, dynamic>.from(value as Map);
        final video = Video.fromJson(videoData);
        
        // Apply filters
        bool shouldInclude = true;
        
        if (categoryId != null && video.categoryId != categoryId) {
          shouldInclude = false;
        }
        
        if (featured != null && video.featured != featured) {
          shouldInclude = false;
        }
        
        if (shouldInclude) {
          videos.add(video);
        }
      });
      
      // Sort by createdAt (newest first)
      videos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return videos;
    } catch (e) {
      print('Error fetching videos: $e');
      return [];
    }
  }
  
  /// Get a single video by ID
  Future<Video?> getVideo(String videoId) async {
    try {
      final snapshot = await _database.child('videos').child(videoId).get();
      
      if (!snapshot.exists) {
        return null;
      }
      
      final videoData = Map<String, dynamic>.from(snapshot.value as Map);
      return Video.fromJson(videoData);
    } catch (e) {
      print('Error fetching video: $e');
      return null;
    }
  }
  
  /// Get user's watch history
  Future<List<WatchHistory>> getWatchHistory(String userId) async {
    try {
      final snapshot = await _database
          .child('users')
          .child(userId)
          .child('watchHistory')
          .get();
      
      if (!snapshot.exists) {
        return [];
      }
      
      final historyMap = Map<String, dynamic>.from(snapshot.value as Map);
      final history = <WatchHistory>[];
      
      historyMap.forEach((key, value) {
        final historyData = Map<String, dynamic>.from(value as Map);
        history.add(WatchHistory.fromJson(historyData));
      });
      
      // Sort by watchedAt (most recent first)
      history.sort((a, b) => b.watchedAt.compareTo(a.watchedAt));
      
      return history;
    } catch (e) {
      print('Error fetching watch history: $e');
      return [];
    }
  }
  
  /// Get videos from watch history with full video details
  Future<List<Video>> getWatchedVideos(String userId) async {
    try {
      final history = await getWatchHistory(userId);
      final videos = <Video>[];
      
      for (final item in history) {
        final video = await getVideo(item.videoId);
        if (video != null) {
          videos.add(video);
        }
      }
      
      return videos;
    } catch (e) {
      print('Error fetching watched videos: $e');
      return [];
    }
  }
  
  /// Add video to watch history
  Future<void> addToWatchHistory(String userId, String videoId) async {
    try {
      await _database
          .child('users')
          .child(userId)
          .child('watchHistory')
          .child(videoId)
          .set({
        'videoId': videoId,
        'watchedAt': DateTime.now().toIso8601String(),
        'progress': 0.0,
      });
    } catch (e) {
      print('Error adding to watch history: $e');
      rethrow;
    }
  }
  
  /// Update watch progress
  Future<void> updateWatchProgress(
    String userId,
    String videoId,
    double progress,
  ) async {
    try {
      await _database
          .child('users')
          .child(userId)
          .child('watchHistory')
          .child(videoId)
          .update({
        'progress': progress,
        'watchedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating watch progress: $e');
      rethrow;
    }
  }
  
  /// Get category by ID
  Future<Category?> getCategory(String categoryId) async {
    try {
      final snapshot = await _database.child('categories').child(categoryId).get();
      
      if (!snapshot.exists) {
        return null;
      }
      
      final categoryData = Map<String, dynamic>.from(snapshot.value as Map);
      return Category.fromJson(categoryData);
    } catch (e) {
      print('Error fetching category: $e');
      return null;
    }
  }
}
