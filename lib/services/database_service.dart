import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad_project/models/category.dart';
import 'package:mad_project/models/video.dart';
import 'package:mad_project/models/watch_history.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Categories ────────────────────────────────────────────────────────────

  /// Get all categories ordered by [order] field
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => Category.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  /// Get a single category by ID
  Future<Category?> getCategory(String categoryId) async {
    try {
      final doc =
          await _firestore.collection('categories').doc(categoryId).get();

      if (!doc.exists) return null;
      return Category.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      print('Error fetching category: $e');
      return null;
    }
  }

  /// [ADMIN ONLY] Add a new category to Firestore.
  /// Returns the auto-generated document ID.
  Future<String> addCategory({
    required String name,
    String icon = '',
    String color1 = '#FF6B35',
    String color2 = '#FF8F65',
  }) async {
    try {
      // Get the current count to set order
      final snapshot = await _firestore.collection('categories').get();
      final order = snapshot.docs.length;

      final docRef = _firestore.collection('categories').doc();
      await docRef.set({
        'id': docRef.id,
        'name': name.trim(),
        'icon': icon,
        'color1': color1,
        'color2': color2,
        'order': order,
        'videoCount': 0,
      });

      print('Category added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error adding category: $e');
      rethrow;
    }
  }

  // ─── Videos ────────────────────────────────────────────────────────────────

  /// Get all videos, optionally filtered by [categoryId] and/or [featured].
  /// Filters are applied client-side to avoid requiring Firestore composite indexes.
  Future<List<Video>> getVideos({
    String? categoryId,
    bool? featured,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .get();

      List<Video> videos = snapshot.docs
          .map((doc) => Video.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Filter client-side to avoid composite index requirements
      videos = videos.where((v) => v.isActive).toList();

      if (categoryId != null) {
        videos = videos.where((v) => v.categoryId == categoryId).toList();
      }
      if (featured != null) {
        videos = videos.where((v) => v.featured == featured).toList();
      }

      return videos;
    } catch (e) {
      print('Error fetching videos: $e');
      return [];
    }
  }

  /// Get a single video by ID
  Future<Video?> getVideo(String videoId) async {
    try {
      final doc = await _firestore.collection('videos').doc(videoId).get();

      if (!doc.exists) return null;
      return Video.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      print('Error fetching video: $e');
      return null;
    }
  }

  // ─── Watch History ─────────────────────────────────────────────────────────

  /// Get user's watch history (most recent first)
  Future<List<WatchHistory>> getWatchHistory(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_history')
          .orderBy('watchedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WatchHistory.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching watch history: $e');
      return [];
    }
  }

  /// Get full Video objects from a user's watch history
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

  /// Add or update a video in the user's watch history
  Future<void> addToWatchHistory(String userId, String videoId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_history')
          .doc(videoId)
          .set({
        'videoId': videoId,
        'watchedAt': FieldValue.serverTimestamp(),
        'progress': 0.0,
        'durationWatched': 0,
        'completedAt': null,
      });
    } catch (e) {
      print('Error adding to watch history: $e');
      rethrow;
    }
  }

  /// Update watch progress for a video in the user's history
  Future<void> updateWatchProgress(
    String userId,
    String videoId,
    double progress,
  ) async {
    try {
      final Map<String, dynamic> updates = {
        'progress': progress,
        'watchedAt': FieldValue.serverTimestamp(),
      };

      // Mark as completed when progress reaches 95%
      if (progress >= 95.0) {
        updates['completedAt'] = FieldValue.serverTimestamp();
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_history')
          .doc(videoId)
          .update(updates);
    } catch (e) {
      print('Error updating watch progress: $e');
      rethrow;
    }
  }

  // ─── Admin: Video Management ───────────────────────────────────────────────

  /// [ADMIN ONLY] Add a new video to Firestore.
  /// Returns the auto-generated document ID.
  Future<String> addVideo({
    required String title,
    required String description,
    required String categoryId,
    required String thumbnailUrl,
    required String videoUrl,
    required int duration,
    required String adminUid,
    bool featured = false,
    List<String> tags = const [],
  }) async {
    try {
      final docRef = _firestore.collection('videos').doc();

      await docRef.set({
        'id': docRef.id,
        'title': title.trim(),
        'description': description.trim(),
        'categoryId': categoryId,
        'thumbnailUrl': thumbnailUrl.trim(),
        'videoUrl': videoUrl.trim(),
        'duration': duration,
        'featured': featured,
        'isActive': true,
        'viewCount': 0,
        'tags': tags,
        'addedBy': adminUid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Increment videoCount on the category atomically
      await _firestore
          .collection('categories')
          .doc(categoryId)
          .update({'videoCount': FieldValue.increment(1)});

      print('Video added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error adding video: $e');
      rethrow;
    }
  }

  /// [ADMIN ONLY] Update an existing video's fields.
  Future<void> updateVideo(String videoId, Map<String, dynamic> fields) async {
    try {
      fields['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('videos').doc(videoId).update(fields);
      print('Video $videoId updated.');
    } catch (e) {
      print('Error updating video: $e');
      rethrow;
    }
  }

  /// [ADMIN ONLY] Soft-delete a video (sets isActive = false).
  /// Also decrements the category's videoCount.
  Future<void> deleteVideo(String videoId) async {
    try {
      final doc = await _firestore.collection('videos').doc(videoId).get();
      if (!doc.exists) throw Exception('Video not found.');

      final categoryId = doc.data()?['categoryId'] as String?;

      await _firestore.collection('videos').doc(videoId).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (categoryId != null) {
        await _firestore
            .collection('categories')
            .doc(categoryId)
            .update({'videoCount': FieldValue.increment(-1)});
      }

      print('Video $videoId soft-deleted.');
    } catch (e) {
      print('Error deleting video: $e');
      rethrow;
    }
  }
}
