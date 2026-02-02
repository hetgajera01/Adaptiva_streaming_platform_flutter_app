import 'package:flutter/material.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/widgets/custom_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final VoidCallback onSignOut;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.onSignOut,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_4, color: Colors.white),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: widget.onSignOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),

            // Featured Section
            _buildFeaturedSection(),

            // Features Grid
            _buildFeaturesSection(isMobile),

            // Recent Items Section
            _buildRecentItemsSection(),

            const SizedBox(height: AppConstants.spacingLarge),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new item feature!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Item'),
        backgroundColor: AppTheme.primaryColor,
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
            icon: Icon(Icons.search),
            label: 'Search',
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
            'Welcome Back! 👋',
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

  Widget _buildFeaturedSection() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured',
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          // Featured Card
          CustomCard(
            elevation: 4,
            borderRadius: AppConstants.radiusXLarge,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Featured item tapped!')),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.secondaryColor,
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusLarge),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.white30,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMedium),

                // Content
                Text(
                  'Amazing Content Here',
                  style: AppTheme.headlineMedium.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover the latest and greatest content available',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMedium),

                // Watch Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Playing content!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLarge),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.play_arrow, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Watch Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(bool isMobile) {
    final features = [
      FeatureCard(
        title: 'Movies',
        description: 'Watch latest blockbuster movies',
        icon: Icons.movie,
        iconColor: AppTheme.primaryColor,
      ),
      FeatureCard(
        title: 'Series',
        description: 'Binge-watch amazing TV series',
        icon: Icons.tv,
        iconColor: AppTheme.secondaryColor,
      ),
      FeatureCard(
        title: 'Documentaries',
        description: 'Learn from real-world stories',
        icon: Icons.document_scanner,
        iconColor: AppTheme.successColor,
      ),
      FeatureCard(
        title: 'Kids',
        description: 'Safe content for children',
        icon: Icons.child_care,
        iconColor: AppTheme.warningColor,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          // Features Grid
          GridView.count(
            crossAxisCount: isMobile ? 2 : 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppConstants.spacingMedium,
            mainAxisSpacing: AppConstants.spacingMedium,
            childAspectRatio: 0.9,
            children: features
                .map(
                  (feature) => GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${feature.title} tapped!')),
                      );
                    },
                    child: feature,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItemsSection() {
    final items = [
      {'title': 'Sci-Fi Adventure', 'category': 'Movies'},
      {'title': 'Comedy Series', 'category': 'Series'},
      {'title': 'Nature Documentary', 'category': 'Documentary'},
      {'title': 'Action Thriller', 'category': 'Movies'},
    ];

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Continue Watching',
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppConstants.spacingMedium),
            itemBuilder: (context, index) {
              final item = items[index];
              return CustomCard(
                elevation: 1,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Playing: ${item['title']}')),
                  );
                },
                child: Row(
                  children: [
                    // Thumbnail
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.7),
                            AppTheme.secondaryColor.withOpacity(0.7),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLarge),
                      ),
                      child: const Icon(
                        Icons.image,
                        color: Colors.white30,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMedium),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['title'] ?? '',
                            style: AppTheme.titleMedium.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['category'] ?? '',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Play Icon
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    String message;
    switch (index) {
      case 0:
        message = 'Home';
        break;
      case 1:
        message = 'Categories';
        break;
      case 2:
        message = 'Search';
        break;
      case 3:
        message = 'Profile';
        break;
      default:
        message = 'Navigation';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message section tapped!'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
