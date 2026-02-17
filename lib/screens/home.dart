import 'package:flutter/material.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/screens/settings.dart';
import 'package:mad_project/screens/category.dart';
import 'package:mad_project/screens/profile.dart';
import 'package:mad_project/services/database_service.dart';
import 'package:mad_project/services/auth_service.dart';
import 'package:mad_project/models/video.dart';
import 'package:mad_project/screens/video_player_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onSignOut;

  const HomeScreen({
    super.key,
    required this.onSignOut,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  List<Video> _featuredVideos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeaturedVideos();
  }

  Future<void> _loadFeaturedVideos() async {
    setState(() => _isLoading = true);
    
    final videos = await _databaseService.getVideos(featured: true);
    
    if (mounted) {
      setState(() {
        _featuredVideos = videos;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          AppConstants.appName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),

            // Featured Videos Section
            const SizedBox(height: AppConstants.spacingLarge),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLarge,
              ),
              child: Text(
                'Featured Videos',
                style: AppTheme.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            
            // Loading or Content
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(AppConstants.spacingXLarge),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _featuredVideos.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingLarge,
                        ),
                        itemCount: _featuredVideos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppConstants.spacingMedium,
                            ),
                            child: _buildVideoCard(_featuredVideos[index]),
                          );
                        },
                      ),
            const SizedBox(height: AppConstants.spacingLarge),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _handleBottomNavigation(index);
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: AppTheme.displaySmall.copyWith(
              color: AppTheme.textPrimary,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore and enjoy unlimited content',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search content...',
              hintStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textTertiary,
              ),
              prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                borderSide: const BorderSide(color: AppTheme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                borderSide: const BorderSide(color: AppTheme.dividerColor),
              ),
              filled: true,
              fillColor: AppTheme.backgroundColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXLarge),
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
              'No videos available',
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Featured videos will appear here',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(Video video) {
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please sign in to watch videos'),
              duration: Duration(milliseconds: 1500),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusMedium),
                  topRight: Radius.circular(AppConstants.radiusMedium),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 60,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            // Video Info
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.description,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        video.getFormattedDuration(),
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }






  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        // Navigate to Categories
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CategoriesScreen(),
          ),
        );
        break;
      case 2:
        // Navigate to Settings
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsScreen(onSignOut: widget.onSignOut),
          ),
        );
        break;
      case 3:
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(onSignOut: widget.onSignOut),
          ),
        );
        break;
    }
  }
}
