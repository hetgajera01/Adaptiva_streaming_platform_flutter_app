import 'package:flutter/material.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/services/auth_service.dart';
import 'package:mad_project/services/database_service.dart';
import 'package:mad_project/models/video.dart';
import 'package:mad_project/screens/video_player_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onSignOut;

  const ProfileScreen({
    super.key,
    required this.onSignOut,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  List<Video> _watchedVideos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWatchedVideos();
  }

  Future<void> _loadWatchedVideos() async {
    setState(() => _isLoading = true);
    
    final user = _authService.currentUser;
    if (user != null) {
      final videos = await _databaseService.getWatchedVideos(user.id);
      
      if (mounted) {
        setState(() {
          _watchedVideos = videos;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.spacingXLarge,
              ),
              child: Column(
                children: [
                  // Profile Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(user?.name ?? 'User'),
                        style: AppTheme.displaySmall.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                  // User Name
                  Text(
                    user?.name ?? 'User',
                    style: AppTheme.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // User Email
                  Text(
                    user?.email ?? 'user@example.com',
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Watched Videos Section
                  Text(
                    'Watched Videos',
                    style: AppTheme.headlineMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                  
                  // Loading or Content
                  _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppConstants.spacingLarge),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _watchedVideos.isEmpty
                          ? _buildEmptyWatchHistory()
                          : Column(
                              children: _watchedVideos.take(5).map((video) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppConstants.spacingSmall,
                                  ),
                                  child: _buildWatchedVideoCard(video),
                                );
                              }).toList(),
                            ),

                  const SizedBox(height: AppConstants.spacingXLarge),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit profile feature coming soon!'),
                            duration: Duration(milliseconds: 1500),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMedium,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingMedium),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.errorColor,
                        side: const BorderSide(color: AppTheme.errorColor),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Widget _buildEmptyWatchHistory() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXLarge),
      child: Column(
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 60,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'No videos watched yet',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start watching to see your history here',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWatchedVideoCard(Video video) {
    return GestureDetector(
      onTap: () {
        final user = _authService.currentUser;
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                video: video,
                userId: user.id,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: const Icon(
                Icons.play_circle_outline,
                color: AppTheme.primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.getFormattedDuration(),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onSignOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
