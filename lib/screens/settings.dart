import 'package:flutter/material.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onSignOut;

  const SettingsScreen({
    super.key,
    required this.onSignOut,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  
  // Settings state
  String _selectedVideoQuality = 'Auto';
  bool _notificationsEnabled = true;
  bool _autoPlayEnabled = true;
  bool _downloadOnWifiOnly = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedVideoQuality = prefs.getString('video_quality') ?? 'Auto';
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _autoPlayEnabled = prefs.getBool('autoplay_enabled') ?? true;
      _downloadOnWifiOnly = prefs.getBool('download_wifi_only') ?? true;
    });
  }

  /// Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('video_quality', _selectedVideoQuality);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('autoplay_enabled', _autoPlayEnabled);
    await prefs.setBool('download_wifi_only', _downloadOnWifiOnly);
  }

  /// Handle logout
  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Sign Out',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoggingOut = true);

      try {
        await _authService.signOut();
        if (mounted) {
          widget.onSignOut();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to sign out: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoggingOut = false);
        }
      }
    }
  }

  /// Show video quality selector
  Future<void> _showVideoQualitySelector() async {
    final qualities = ['Auto', '1080p', '720p', '480p', '360p'];
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Video Quality',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: qualities.map((quality) {
            return RadioListTile<String>(
              title: Text(
                quality,
                style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
              ),
              value: quality,
              groupValue: _selectedVideoQuality,
              activeColor: AppTheme.accentColor,
              onChanged: (value) {
                setState(() => _selectedVideoQuality = value!);
                _saveSettings();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Settings',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoggingOut
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.accentColor),
                  const SizedBox(height: 16),
                  Text(
                    'Signing out...',
                    style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Section
                  _buildSectionHeader('Account'),
                  _buildAccountCard(user),

                  const SizedBox(height: AppConstants.spacingLarge),

                  // Playback Settings
                  _buildSectionHeader('Playback'),
                  _buildSettingsCard([
                    _buildSettingTile(
                      icon: Icons.high_quality,
                      title: 'Video Quality',
                      subtitle: _selectedVideoQuality,
                      onTap: _showVideoQualitySelector,
                      trailing: const Icon(Icons.chevron_right, color: AppTheme.textTertiary),
                    ),
                    _buildDivider(),
                    _buildSwitchTile(
                      icon: Icons.play_circle_outline,
                      title: 'Auto-Play',
                      subtitle: 'Play next episode automatically',
                      value: _autoPlayEnabled,
                      onChanged: (value) {
                        setState(() => _autoPlayEnabled = value);
                        _saveSettings();
                      },
                    ),
                  ]),

                  const SizedBox(height: AppConstants.spacingLarge),

                  // Download Settings
                  _buildSectionHeader('Downloads'),
                  _buildSettingsCard([
                    _buildSwitchTile(
                      icon: Icons.wifi,
                      title: 'Wi-Fi Only',
                      subtitle: 'Download only on Wi-Fi',
                      value: _downloadOnWifiOnly,
                      onChanged: (value) {
                        setState(() => _downloadOnWifiOnly = value);
                        _saveSettings();
                      },
                    ),
                  ]),

                  const SizedBox(height: AppConstants.spacingLarge),

                  // Notifications
                  _buildSectionHeader('Notifications'),
                  _buildSettingsCard([
                    _buildSwitchTile(
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Receive updates and recommendations',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                        _saveSettings();
                      },
                    ),
                  ]),

                  const SizedBox(height: AppConstants.spacingLarge),

                  // About Section
                  _buildSectionHeader('About'),
                  _buildSettingsCard([
                    _buildSettingTile(
                      icon: Icons.info_outline,
                      title: 'App Version',
                      subtitle: '1.0.0',
                      onTap: null,
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Privacy Policy')),
                        );
                      },
                      trailing: const Icon(Icons.chevron_right, color: AppTheme.textTertiary),
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terms of Service')),
                        );
                      },
                      trailing: const Icon(Icons.chevron_right, color: AppTheme.textTertiary),
                    ),
                  ]),

                  const SizedBox(height: AppConstants.spacingXLarge),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.logout, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingXLarge),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLarge,
        vertical: AppConstants.spacingSmall,
      ),
      child: Text(
        title,
        style: AppTheme.titleMedium.copyWith(
          color: AppTheme.textTertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAccountCard(User? user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: AppTheme.headlineLarge.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMedium),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User',
                  style: AppTheme.headlineSmall.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Edit Icon
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.textTertiary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile feature')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.accentColor, size: 24),
      ),
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.accentColor, size: 24),
      ),
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.accentColor,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.dividerColor.withOpacity(0.3),
      indent: 72,
    );
  }
}
