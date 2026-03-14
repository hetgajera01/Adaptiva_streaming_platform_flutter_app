import 'package:flutter/material.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/models/category.dart';
import 'package:mad_project/services/auth_service.dart';
import 'package:mad_project/services/database_service.dart';
import 'package:mad_project/screens/admin_video_list_screen.dart';

class AdminUploadScreen extends StatefulWidget {
  final AuthService authService;

  const AdminUploadScreen({super.key, required this.authService});

  @override
  State<AdminUploadScreen> createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  // Form controllers
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _thumbnailCtrl = TextEditingController();
  final _videoUrlCtrl = TextEditingController();

  String? _selectedCategoryId;
  bool _isLoading = false;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _thumbnailCtrl.dispose();
    _videoUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final cats = await _db.getCategories();
    if (mounted) {
      setState(() => _categories = cats);
    }
  }

  /// Show dialog to create a new category
  Future<void> _showCreateCategoryDialog() async {
    final nameCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.add_circle, color: AppTheme.accentColor),
            const SizedBox(width: 10),
            Text(
              'New Category',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 18),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameCtrl,
            autofocus: true,
            style: TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              labelText: 'Category Name',
              hintText: 'e.g. Action, Comedy, Drama',
              labelStyle: TextStyle(color: AppTheme.textSecondary),
              hintStyle: TextStyle(color: AppTheme.textTertiary, fontSize: 13),
              prefixIcon:
                  Icon(Icons.category, color: AppTheme.accentColor),
              filled: true,
              fillColor: AppTheme.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: AppTheme.accentColor, width: 2),
              ),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter a category name' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, nameCtrl.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final newId = await _db.addCategory(name: result);
        await _loadCategories();
        if (mounted) {
          setState(() => _selectedCategoryId = newId);
          _showSnack('✅ Category "$result" created!');
        }
      } catch (e) {
        if (mounted) {
          _showSnack('Error creating category: $e', isError: true);
        }
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      _showSnack('Please select a category.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final adminUid = widget.authService.currentUser!.id;

      final videoId = await _db.addVideo(
        title: _titleCtrl.text,
        description: _descCtrl.text,
        categoryId: _selectedCategoryId!,
        thumbnailUrl: _thumbnailCtrl.text,
        videoUrl: _videoUrlCtrl.text,
        duration: 0,
        adminUid: adminUid,
      );

      if (mounted) {
        _showSnack('✅ Video uploaded! ID: $videoId');
        _formKey.currentState!.reset();
        _titleCtrl.clear();
        _descCtrl.clear();
        _thumbnailCtrl.clear();
        _videoUrlCtrl.clear();
        setState(() {
          _selectedCategoryId = null;
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnack('Error: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    // ── Admin Guard ──────────────────────────────────────────────────────────
    if (!widget.authService.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Upload')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 72, color: AppTheme.errorColor),
              const SizedBox(height: 16),
              Text(
                'Access Denied',
                style: AppTheme.headlineLarge.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Only admins can upload videos.',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Admin Upload Form ────────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimary,
        title: Row(
          children: [
            Icon(Icons.admin_panel_settings, color: AppTheme.accentColor),
            const SizedBox(width: 10),
            Text(
              'Upload Video',
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminVideoListScreen(
                    authService: widget.authService,
                  ),
                ),
              );
            },
            icon: Icon(Icons.video_settings, color: AppTheme.accentColor),
            tooltip: 'Manage Videos',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('Video Details'),
              const SizedBox(height: 12),

              // Title
              _buildField(
                controller: _titleCtrl,
                label: 'Title',
                hint: 'e.g. Big Buck Bunny',
                icon: Icons.title,
                validator: (v) =>
                    v!.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 14),

              // Description
              _buildField(
                controller: _descCtrl,
                label: 'Description',
                hint: 'Short description of the video...',
                icon: Icons.description,
                maxLines: 3,
                validator: (v) =>
                    v!.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 20),

              // Category Dropdown
              _sectionLabel('Category'),
              const SizedBox(height: 8),
              _buildDropdown(),
              const SizedBox(height: 20),

              _sectionLabel('URLs'),
              const SizedBox(height: 12),

              // Thumbnail URL
              _buildField(
                controller: _thumbnailCtrl,
                label: 'Thumbnail URL',
                hint: 'https://cdn.example.com/thumb.jpg',
                icon: Icons.image,
                validator: (v) =>
                    v!.trim().isEmpty ? 'Thumbnail URL is required' : null,
              ),
              const SizedBox(height: 14),

              // Video URL
              _buildField(
                controller: _videoUrlCtrl,
                label: 'Video URL',
                hint: 'https://cdn.example.com/video.mp4',
                icon: Icons.video_library,
                validator: (v) {
                  if (v!.trim().isEmpty) return 'Video URL is required';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppTheme.textPrimary),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(
                    _isLoading ? 'Uploading...' : 'Upload Video',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: AppTheme.labelMedium.copyWith(
        color: AppTheme.accentColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.accentColor),
        labelStyle: TextStyle(color: AppTheme.textSecondary),
        hintStyle: TextStyle(color: AppTheme.textTertiary, fontSize: 13),
        filled: true,
        fillColor: AppTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.errorColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Column(
      children: [
        // Category dropdown — shows only categories fetched from Firestore
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _selectedCategoryId == null
                  ? Colors.transparent
                  : AppTheme.accentColor,
              width: 2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategoryId,
              isExpanded: true,
              dropdownColor: AppTheme.surfaceColor,
              hint: Text('Select Category',
                  style: TextStyle(color: AppTheme.textTertiary)),
              icon:
                  Icon(Icons.expand_more, color: AppTheme.infoColor),
              onChanged: (val) =>
                  setState(() => _selectedCategoryId = val),
              items: _categories
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.name,
                          style: TextStyle(color: AppTheme.textPrimary)),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // "+ Create New Category" button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showCreateCategoryDialog,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Create New Category'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accentColor,
              side: BorderSide(
                  color: AppTheme.accentColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
