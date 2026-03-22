import 'package:flutter/material.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/models/category.dart' as cat_model;
import 'package:mad_project/models/video.dart';
import 'package:mad_project/services/database_service.dart';
import 'package:mad_project/screens/video_player_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CategoryVideosScreen extends StatefulWidget {
  final cat_model.Category category;

  const CategoryVideosScreen({super.key, required this.category});

  @override
  State<CategoryVideosScreen> createState() => _CategoryVideosScreenState();
}

class _CategoryVideosScreenState extends State<CategoryVideosScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Video> _videos = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      // Check internet connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = 'No internet connection';
          });
        }
        return;
      }

      final videos = await _databaseService.getVideos(
        categoryId: widget.category.id,
      );

      if (mounted) {
        setState(() {
          _videos = videos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Unable to fetch data';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        title: Text(
          widget.category.name,
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppTheme.accentColor),
            )
          : _hasError
              ? _buildErrorState()
              : _videos.isEmpty
                  ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadVideos,
                  color: AppTheme.accentColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.spacingMedium),
                    itemCount: _videos.length,
                    itemBuilder: (context, index) =>
                        _buildVideoCard(_videos[index]),
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 80,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'No videos yet',
            style: AppTheme.headlineMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Videos in "${widget.category.name}" will appear here',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final isNoInternet = _errorMessage.contains('No internet');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isNoInternet ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
            size: 80,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            _errorMessage,
            style: AppTheme.headlineMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isNoInternet
                ? 'Please check your connection and try again'
                : 'Something went wrong while loading videos',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          ElevatedButton.icon(
            onPressed: _loadVideos,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Retry', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Video video) {
    return GestureDetector(
      onTap: () {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              video: video,
              userId: userId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(color: AppTheme.dividerColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusMedium),
                bottomLeft: Radius.circular(AppConstants.radiusMedium),
              ),
              child: SizedBox(
                width: 140,
                height: 100,
                child: Image.network(
                  video.thumbnailUrl.replaceAll('+', '%20'),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 40,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Video Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: AppTheme.titleSmall.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.description,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          video.getFormattedDuration(),
                          style: AppTheme.labelSmall.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Play icon
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.play_arrow_rounded,
                color: AppTheme.accentColor,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
