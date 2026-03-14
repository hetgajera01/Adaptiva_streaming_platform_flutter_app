import 'package:flutter/material.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/models/video.dart';
import 'package:mad_project/services/auth_service.dart';
import 'package:mad_project/services/database_service.dart';
import 'package:mad_project/screens/admin_edit_video_screen.dart';

class AdminVideoListScreen extends StatefulWidget {
  final AuthService authService;

  const AdminVideoListScreen({super.key, required this.authService});

  @override
  State<AdminVideoListScreen> createState() => _AdminVideoListScreenState();
}

class _AdminVideoListScreenState extends State<AdminVideoListScreen> {
  final _db = DatabaseService();
  List<Video> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() => _isLoading = true);
    final videos = await _db.getVideos();
    if (mounted) {
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmDelete(Video video) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.errorColor),
            const SizedBox(width: 10),
            Text(
              'Delete Video',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this video?',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.videocam, color: AppTheme.accentColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      video.title,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _db.deleteVideo(video.id);
        if (mounted) {
          _showSnack('✅ "${video.title}" deleted successfully');
          _loadVideos();
        }
      } catch (e) {
        if (mounted) {
          _showSnack('Error deleting video: $e', isError: true);
        }
      }
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.errorColor : AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── Admin Guard ──
    if (!widget.authService.isAdmin) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(title: const Text('Manage Videos')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 72, color: AppTheme.errorColor),
              const SizedBox(height: 16),
              Text(
                'Access Denied',
                style: AppTheme.headlineLarge.copyWith(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Only admins can manage videos.',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimary,
        title: Row(
          children: [
            Icon(Icons.video_settings, color: AppTheme.accentColor),
            const SizedBox(width: 10),
            Text(
              'Manage Videos',
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
          : _videos.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadVideos,
                  color: AppTheme.accentColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _videos.length,
                    itemBuilder: (context, index) =>
                        _buildVideoTile(_videos[index]),
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 80, color: AppTheme.textTertiary),
          const SizedBox(height: 16),
          Text(
            'No videos found',
            style: AppTheme.headlineMedium.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload videos to manage them here.',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoTile(Video video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.dividerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: SizedBox(
              width: 120,
              height: 90,
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
                      child: Icon(Icons.videocam, size: 36, color: AppTheme.accentColor),
                    ),
                  );
                },
              ),
            ),
          ),

          // Video Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: AppTheme.titleSmall.copyWith(color: AppTheme.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.description,
                    style: AppTheme.bodySmall.copyWith(color: AppTheme.textTertiary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminEditVideoScreen(
                        authService: widget.authService,
                        video: video,
                      ),
                    ),
                  ).then((_) => _loadVideos());
                },
                icon: Icon(Icons.edit, color: AppTheme.infoColor, size: 22),
                tooltip: 'Edit',
              ),
              // Delete
              IconButton(
                onPressed: () => _confirmDelete(video),
                icon: Icon(Icons.delete_outline, color: AppTheme.errorColor, size: 22),
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
