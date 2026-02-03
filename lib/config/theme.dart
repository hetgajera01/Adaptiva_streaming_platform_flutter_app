import 'package:flutter/material.dart';

/// Global theme configuration for PulseStream
class AppTheme {
  // ================= 🎨 PRIMARY COLORS =================
  static const Color primaryColor = Color(0xFF0F172A); // Charcoal Black
  static const Color primaryLight = Color(0xFF1E293B); // Dark Slate
  static const Color primaryDark = Color(0xFF0A0F1A); // Darker Charcoal
  static const Color primaryVariant = Color(0xFF1A222F); // Medium Charcoal

  // ================= 🎨 SECONDARY COLORS =================
  static const Color secondaryColor = Color(0xFF1E293B); // Dark Slate
  static const Color secondaryLight = Color(0xFF334155); // Medium Slate
  static const Color secondaryDark = Color(0xFF0F172A); // Charcoal Black

  // ================= 🎨 ACCENT & BRAND COLORS =================
  static const Color accentColor = Color(0xFFE50914); // Crimson Red
  static const Color successColor = Color(0xFF10B981); // Emerald Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color infoColor = Color(0xFF3B82F6); // Blue

  // ================= 🎨 NEUTRAL COLORS =================
  static const Color backgroundColor = Color(0xFF0F172A); // Charcoal Black
  static const Color surfaceColor = Color(0xFF1E293B); // Dark Slate
  static const Color dividerColor = Color(0xFF475569); // Dark Gray
  static const Color shadowColor = Color(0x1A000000); // Shadow

  // ================= 🎨 TEXT COLORS =================
  static const Color textPrimary = Color(0xFFF8FAFC); // Soft White
  static const Color textSecondary = Color(0xFFCBD5E1); // Light Gray
  static const Color textTertiary = Color(0xFF94A3B8); // Cool Gray
  static const Color textHint = Color(0xFF64748B); // Medium Gray

  // ================= 🖋 TYPOGRAPHY CONFIGURATION =================
  static const String fontFamily = 'Roboto';
  static const String fontFamilyAlt = 'Poppins';

  // Display styles for streaming platform headers
  static const TextStyle displayLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
    fontFamily: fontFamily,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    height: 1.25,
    fontFamily: fontFamily,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    fontFamily: fontFamily,
  );

  // Headline styles for content titles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.35,
    fontFamily: fontFamily,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    fontFamily: fontFamily,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.45,
    fontFamily: fontFamily,
  );

  // Title styles for subsections
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    fontFamily: fontFamily,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    fontFamily: fontFamily,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    fontFamily: fontFamily,
  );

  // Body text styles for content
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    fontFamily: fontFamily,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    fontFamily: fontFamily,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    fontFamily: fontFamily,
  );

  // Label styles for buttons and tags
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    fontFamily: fontFamily,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    fontFamily: fontFamily,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.45,
    fontFamily: fontFamily,
  );

  // ================= 🌙 LIGHT THEME =================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentColor,
      primary: primaryColor,
      onPrimary: textPrimary,
      primaryContainer: primaryLight,
      onPrimaryContainer: textPrimary,
      secondary: secondaryColor,
      onSecondary: textPrimary,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: textPrimary,
      tertiary: accentColor,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFB3BA),
      onTertiaryContainer: Color(0xFF700710),
      error: errorColor,
      onError: Colors.white,
      errorContainer: Color(0xFFFFEDEB),
      onErrorContainer: Color(0xFF7A1D1A),
      outline: Color(0xFF94A3B8),
      outlineVariant: Color(0xFF64748B),
      surface: backgroundColor,
      onSurface: textPrimary,
      surfaceVariant: Color(0xFF334155),
      brightness: Brightness.light,
    ),

    // Typography
    fontFamily: fontFamily,
    textTheme: const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF8FAFC),
        fontFamily: fontFamily,
      ),
      iconTheme: const IconThemeData(color: Color(0xFFF8FAFC)),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Color(0xFF64748B),
        disabledForegroundColor: Color(0xFF94A3B8),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        textStyle: labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: labelLarge,
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        side: BorderSide(color: accentColor, width: 1.5),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: labelLarge,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1E293B),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: bodyMedium.copyWith(color: textSecondary),
      hintStyle: bodyMedium.copyWith(color: textTertiary),
      errorStyle: labelSmall.copyWith(color: errorColor),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return accentColor;
        return textSecondary;
      }),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(0),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFFEEEEEE),
      disabledColor: Color(0xFFBDBDBD),
      selectedColor: primaryColor,
      secondarySelectedColor: secondaryColor,
      labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      brightness: Brightness.light,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: accentColor,
      unselectedItemColor: textSecondary,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceColor,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: headlineMedium.copyWith(color: textPrimary),
      contentTextStyle: bodyMedium.copyWith(color: textSecondary),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF323232),
      contentTextStyle: bodyMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 6,
    ),
  );

  // ================= 🌙 DARK THEME =================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentColor,
      primary: primaryColor,
      onPrimary: textPrimary,
      primaryContainer: primaryLight,
      onPrimaryContainer: textPrimary,
      secondary: secondaryColor,
      onSecondary: textPrimary,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: textPrimary,
      tertiary: accentColor,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFB3BA),
      onTertiaryContainer: Color(0xFF700710),
      error: errorColor,
      onError: Colors.white,
      errorContainer: Color(0xFF5F1F1A),
      onErrorContainer: Color(0xFFFFB4AB),
      outline: Color(0xFF94A3B8),
      outlineVariant: Color(0xFF64748B),
      surface: backgroundColor,
      onSurface: textPrimary,
      surfaceVariant: Color(0xFF334155),
      brightness: Brightness.dark,
    ),

    // Typography
    fontFamily: fontFamily,
    textTheme: const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    ).apply(
      bodyColor: Color(0xFFF8FAFC),
      displayColor: Color(0xFFF8FAFC),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textPrimary,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF8FAFC),
        fontFamily: fontFamily,
      ),
      iconTheme: const IconThemeData(color: Color(0xFFF8FAFC)),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Color(0xFF64748B),
        disabledForegroundColor: Color(0xFF94A3B8),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        textStyle: labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: labelLarge,
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        side: BorderSide(color: accentColor, width: 1.5),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: labelLarge,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1E293B),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: bodyMedium.copyWith(color: textSecondary),
      hintStyle: bodyMedium.copyWith(color: textTertiary),
      errorStyle: labelSmall.copyWith(color: errorColor),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return accentColor;
        return textSecondary;
      }),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: primaryLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(0),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF334155),
      disabledColor: Color(0xFF64748B),
      selectedColor: accentColor,
      secondarySelectedColor: accentColor,
      labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      brightness: Brightness.dark,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: accentColor,
      unselectedItemColor: textSecondary,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: primaryLight,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: headlineMedium.copyWith(color: textPrimary),
      contentTextStyle: bodyMedium.copyWith(color: textSecondary),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF323232),
      contentTextStyle: bodyMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 6,
    ),
  );

  // ================= 🎬 ADAPTIVE UTILITIES =================
  /// Get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }

  /// Check if running on mobile
  static bool isMobileSize(double width) => width < 600;

  /// Check if running on tablet
  static bool isTabletSize(double width) => width >= 600 && width < 1200;

  /// Check if running on desktop
  static bool isDesktopSize(double width) => width >= 1200;

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(double screenWidth) {
    if (isMobileSize(screenWidth)) {
      return EdgeInsets.all(16);
    } else if (isTabletSize(screenWidth)) {
      return EdgeInsets.all(24);
    } else {
      return EdgeInsets.all(32);
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    double screenWidth, {
    required double mobileSize,
    double? tabletSize,
    double? desktopSize,
  }) {
    if (isMobileSize(screenWidth)) {
      return mobileSize;
    } else if (isTabletSize(screenWidth)) {
      return tabletSize ?? mobileSize * 1.2;
    } else {
      return desktopSize ?? mobileSize * 1.4;
    }
  }
}
