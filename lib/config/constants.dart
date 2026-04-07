/// Application-wide constants for the streaming platform
class AppConstants {
  // ================= 🎨 BRANDING CONSTANTS =================
  static const String appName = 'PulseStream';
  static const String appVersion = '1.1.0';

  // ================= 📐 SPACING & PADDING CONSTANTS =================
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  // ================= 🔲 BORDER RADIUS CONSTANTS =================
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusMax = 20.0;

  // ================= 📏 RESPONSIVE BREAKPOINTS =================
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // ================= ⏱️ ANIMATION DURATIONS =================
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 750);

  // ================= 🔍 STREAMING PLATFORM CONSTANTS =================
  static const int maxRecentWatched = 20;
  static const int maxRecommendations = 10;
  static const int defaultPageSize = 20;
  static const int requestTimeout = 30; // seconds

  // ================= 🎬 CONTENT CATEGORIES =================
  static const List<String> contentCategories = [
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'Animation',
    'Documentary',
    'Sports',
  ];

  // ================= 🌐 API & NETWORK CONSTANTS =================
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ================= 💾 STORAGE KEYS =================
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserProfile = 'user_profile';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyWatchHistory = 'watch_history';
  static const String keyFavorites = 'favorites';
  static const String keyDeviceId = 'device_id';

  // ================= 🔒 SECURITY CONSTANTS =================
  static const int minPasswordLength = 8;
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);

  // ================= 📱 DEVICE SPECIFIC =================
  static const double mobileMaxWidth = 600.0;
  static const double tabletMaxWidth = 900.0;
  static const double desktopMaxWidth = 1400.0;

  // ================= 🎥 VIDEO QUALITY OPTIONS =================
  static const List<String> videoQualities = [
    'Auto',
    '360p',
    '480p',
    '720p',
    '1080p',
    '4K',
  ];

  // ================= 🌍 LOCALIZATION CONSTANTS =================
  static const List<String> supportedLanguages = ['en', 'es', 'fr', 'de'];
  static const String defaultLanguage = 'en';
}  