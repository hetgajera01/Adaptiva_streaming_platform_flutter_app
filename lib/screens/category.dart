import 'package:flutter/material.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/services/database_service.dart';
import 'package:mad_project/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    
    final categories = await _databaseService.getCategories();
    
    if (mounted) {
      setState(() {
        _categories = categories;
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
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? _buildEmptyState()
              : Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingMedium),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppConstants.spacingMedium,
                    mainAxisSpacing: AppConstants.spacingMedium,
                    children: _categories.map((category) {
                      return _buildCategoryCard(category);
                    }).toList(),
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
            Icons.category_outlined,
            size: 80,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'No categories available',
            style: AppTheme.headlineMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Categories will appear here once added',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    // Parse colors from hex strings
    final color1 = _parseColor(category.color1);
    final color2 = _parseColor(category.color2);
    
    // Map icon name to IconData
    final icon = _getIconData(category.icon);

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${category.name} content coming soon!'),
            duration: const Duration(milliseconds: 1500),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color2],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Text(
              category.name,
              style: AppTheme.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      // Remove # if present
      final hex = hexColor.replaceAll('#', '');
      // Add FF for full opacity if not present
      final fullHex = hex.length == 6 ? 'FF$hex' : hex;
      return Color(int.parse(fullHex, radix: 16));
    } catch (e) {
      // Return default color if parsing fails
      return AppTheme.primaryColor;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'movie_outlined':
        return Icons.movie_outlined;
      case 'tv_outlined':
        return Icons.tv_outlined;
      case 'video_library_outlined':
        return Icons.video_library_outlined;
      case 'sports_soccer_outlined':
        return Icons.sports_soccer_outlined;
      case 'music_note_outlined':
        return Icons.music_note_outlined;
      case 'child_care_outlined':
        return Icons.child_care_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
