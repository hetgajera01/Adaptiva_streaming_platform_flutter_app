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
import 'package:mad_project/screens/admin_upload_screen.dart';
import 'package:mad_project/screens/admin_edit_video_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
  List<Video> _allVideos = [];
  List<Video> _filteredVideos = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterVideos(_searchController.text);
  }

  void _filterVideos(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredVideos = _allVideos;
      } else {
        _filteredVideos = _allVideos
            .where((video) =>
                video.title.toLowerCase().contains(query.toLowerCase()) ||
                video.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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

      final videos = await _databaseService.getVideos();

      if (mounted) {
        setState(() {
          _allVideos = videos;
          _filteredVideos = videos; // Initialize filtered videos
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
      // ── Admin FAB — only visible to admin users ──────────────────────────
      floatingActionButton: _authService.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminUploadScreen(
                      authService: _authService,
                    ),
                  ),
                ).then((_) => _loadVideos());
              },
              backgroundColor: AppTheme.accentColor,
              icon: const Icon(Icons.video_call, color: Colors.white),
              label: const Text(
                'Upload Video',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
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
                'All Videos',
                style: AppTheme.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            
            // Loading, Error, or Content
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(AppConstants.spacingXLarge),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _hasError
                    ? _buildErrorState()
                    : _buildSearchResults(),
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
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search content...',
              hintStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textTertiary,
              ),
              prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        _filterVideos('');
                      },
                    )
                  : null,
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

  Widget _buildSearchResults() {
    if (_filteredVideos.isEmpty && _searchController.text.isNotEmpty) {
      return _buildNoSearchResultsState();
    }
    
    if (_allVideos.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
      itemCount: _filteredVideos.length,
      itemBuilder: (context, index) => _buildVideoCard(_filteredVideos[index]),
    );
  }

  Widget _buildNoSearchResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Text(
              'No results found',
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for something else',
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
              'Upload videos to see them here',
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

  Widget _buildErrorState() {
    final isNoInternet = _errorMessage.contains('No internet');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXLarge),
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
      ),
    );
  }

  Future<void> _confirmDeleteVideo(Video video) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.errorColor),
            const SizedBox(width: 10),
            Text('Delete Video',
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 18)),
          ],
        ),
        content: Text(
          'Delete "${video.title}"?\nThis action cannot be undone.',
          style: TextStyle(color: AppTheme.textSecondary),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _databaseService.deleteVideo(video.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ "${video.title}" deleted'),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _loadVideos();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusMedium),
                topRight: Radius.circular(AppConstants.radiusMedium),
              ),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.network(
                  video.thumbnailUrl.replaceAll('+', '%20'),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 60,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    );
                  },
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
                      const Spacer(),
                      // ── Admin Actions ──
                      if (_authService.isAdmin) ...[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminEditVideoScreen(
                                  authService: _authService,
                                  video: video,
                                ),
                              ),
                            ).then((_) => _loadVideos());
                          },
                          icon: Icon(Icons.edit, color: AppTheme.infoColor, size: 20),
                          tooltip: 'Edit',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () => _confirmDeleteVideo(video),
                          icon: Icon(Icons.delete_outline, color: AppTheme.errorColor, size: 20),
                          tooltip: 'Delete',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                        ),
                      ],
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
