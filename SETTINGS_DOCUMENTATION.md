# Settings Page Documentation

## 🎯 Overview
The Settings page provides comprehensive control over app preferences, playback options, and account management.

## ✨ Features Implemented

### 1. **Account Section**
- Displays user profile with avatar (first letter of name)
- Shows user name and email
- Edit profile button (placeholder for future implementation)

### 2. **Video Quality Selector** ⭐
- **Options Available:**
  - Auto (default) - Automatically adjusts based on network
  - 1080p - Full HD
  - 720p - HD
  - 480p - Standard Definition
  - 360p - Low Definition
- Settings are saved to device using SharedPreferences
- Tap on "Video Quality" to open selector dialog

### 3. **Playback Settings**
- **Auto-Play Toggle**: Automatically play next episode
- Settings persist across app sessions

### 4. **Download Settings**
- **Wi-Fi Only Toggle**: Restrict downloads to Wi-Fi connections only
- Prevents mobile data usage for downloads

### 5. **Notifications**
- **Push Notifications Toggle**: Enable/disable app notifications
- Control updates and recommendations

### 6. **About Section**
- App Version display (1.0.0)
- Privacy Policy link
- Terms of Service link

### 7. **Sign Out Button** ⭐
- Prominent red button at the bottom
- Shows confirmation dialog before signing out
- Displays loading state during sign out
- Clears all session data
- Returns user to login screen

## 🎨 Design Features

### Color Scheme
- **Background**: Charcoal Black (#0F172A)
- **Cards**: Dark Slate (#1E293B)
- **Accent**: Crimson Red (#E50914)
- **Text**: Soft White (#F8FAFC)
- **Icons**: Crimson Red with light background

### UI Components
- **Section Headers**: Organized settings into logical groups
- **Icon Backgrounds**: Rounded squares with accent color tint
- **Switches**: Custom styled with accent color
- **Dividers**: Subtle separators between settings
- **Cards**: Rounded corners with elevation

## 🔧 How to Access

### From Home Screen:
1. Click the **Settings icon** (gear icon) in the top-right corner of the app bar
2. Or use the bottom navigation bar (future implementation)

### Navigation:
- Back arrow in app bar returns to previous screen
- All changes are saved automatically

## 💾 Data Persistence

Settings are saved using **SharedPreferences**:
- `video_quality` - Selected video quality
- `notifications_enabled` - Notification preference
- `autoplay_enabled` - Auto-play preference
- `download_wifi_only` - Download restriction preference

## 🔐 Sign Out Process

1. User taps "Sign Out" button
2. Confirmation dialog appears
3. User confirms sign out
4. Loading indicator shows
5. Session data cleared from:
   - SharedPreferences
   - Auth service
6. User redirected to login screen

## 🚀 Future Enhancements

Potential additions:
- [ ] Edit profile functionality
- [ ] Change password
- [ ] Download management
- [ ] Subtitle preferences
- [ ] Language selection
- [ ] Dark/Light theme toggle
- [ ] Parental controls
- [ ] Viewing history management
- [ ] Cache management

## 📱 Usage Example

```dart
// Navigate to settings from any screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SettingsScreen(
      onSignOut: () {
        // Handle sign out callback
      },
    ),
  ),
);
```

## ⚙️ Technical Details

### Dependencies Used:
- `shared_preferences` - For persistent storage
- `flutter/material.dart` - UI components
- Custom theme and constants

### State Management:
- StatefulWidget for reactive UI
- Local state for settings values
- Async operations for data persistence

### Error Handling:
- Try-catch blocks for sign out
- User-friendly error messages
- Loading states for async operations
