import 'package:flutter/material.dart';

/// Global theme configuration for PulseStream
class AppTheme {
  // ================= 🎨 PRIMARY COLORS =================
  static const Color primaryColor = Color(0xFF6C3FB5); // Deep Purple
  static const Color primaryLight = Color(0xFF9575CD); // Light Purple
  static const Color primaryDark = Color(0xFF4A148C); // Dark Purple
  static const Color primaryVariant = Color(0xFF7E57C2); // Medium Purple

  // ================= 🎨 SECONDARY COLORS =================
  static const Color secondaryColor = Color(0xFF00BCD4); // Cyan
  static const Color secondaryLight = Color(0xFF4DD0E1); // Light Cyan
  static const Color secondaryDark = Color(0xFF0097A7); // Dark Cyan

  // ================= 🎨 ACCENT & BRAND COLORS =================
  static const Color accentColor = Color(0xFFFF006E); // Hot Pink
  static const Color successColor = Color(0xFF00D084); // Mint Green
  static const Color warningColor = Color(0xFFFFAA00); // Golden Orange
  static const Color errorColor = Color(0xFFFF3B30); // Bright Red
  static const Color infoColor = Color(0xFF00B4DB); // Bright Cyan

  // ================= 🎨 NEUTRAL COLORS =================
  static const Color backgroundColor = Color(0xFFFAFAFA); // Light Gray
  static const Color surfaceColor = Color(0xFFFFFFFF); // White
  static const Color dividerColor = Color(0xFFE0E0E0); // Light Divider
  static const Color shadowColor = Color(0x1A000000); // Shadow

  // ================= 🎨 TEXT COLORS =================
  static const Color textPrimary = Color(0xFF212121); // Dark Text
  static const Color textSecondary = Color(0xFF757575); // Medium Text
  static const Color textTertiary = Color(0xFFBDBDBD); // Light Text
  static const Color textHint = Color(0xFFE0E0E0); // Hint Text

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
      seedColor: primaryColor,
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryLight,
      onPrimaryContainer: Color(0xFF001A41),
      secondary: secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: Color(0xFF331A00),
      tertiary: accentColor,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFB2EBF2),
      onTertiaryContainer: Color(0xFF001C2B),
      error: errorColor,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410E0B),
      outline: Color(0xFF79747E),
      outlineVariant: Color(0xFFCAC7D0),
      surface: backgroundColor,
      onSurface: textPrimary,
      surfaceVariant: Color(0xFFEEEEEE),
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
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Color(0xFFBDBDBD),
        disabledForegroundColor: Color(0xFFE0E0E0),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        textStyle: labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: labelLarge,
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor, width: 1.5),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: labelLarge,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFFAFAFA),
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
        borderSide: BorderSide(color: primaryColor, width: 2),
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
        if (states.contains(WidgetState.focused)) return primaryColor;
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
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
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
      seedColor: primaryLight,
      primary: primaryLight,
      onPrimary: Color(0xFF001A41),
      primaryContainer: Color(0xFF0D47A1),
      onPrimaryContainer: primaryLight,
      secondary: secondaryLight,
      onSecondary: Color(0xFF331A00),
      secondaryContainer: Color(0xFFF57F17),
      onSecondaryContainer: secondaryLight,
      tertiary: Color(0xFF80DEEA),
      onTertiary: Color(0xFF001C2B),
      tertiaryContainer: Color(0xFF0F525F),
      onTertiaryContainer: Color(0xFFB2EBF2),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      outline: Color(0xFF938F99),
      outlineVariant: Color(0xFF49454E),
      surface: Color(0xFF121212),
      onSurface: Color(0xFFE8E8E8),
      surfaceVariant: Color(0xFF49454E),
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
      bodyColor: Color(0xFFE8E8E8),
      displayColor: Color(0xFFE8E8E8),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Color(0xFF001A41),
        disabledBackgroundColor: Color(0xFF424242),
        disabledForegroundColor: Color(0xFF757575),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        textStyle: labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: labelLarge,
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        side: BorderSide(color: primaryLight, width: 1.5),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: labelLarge,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF212121),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF424242), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF424242), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFFFB4AB), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFFFB4AB), width: 2),
      ),
      labelStyle: bodyMedium.copyWith(color: Color(0xFFB3B3B3)),
      hintStyle: bodyMedium.copyWith(color: Color(0xFF808080)),
      errorStyle: labelSmall.copyWith(color: Color(0xFFFFB4AB)),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return primaryLight;
        return Color(0xFFB3B3B3);
      }),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(0),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF424242),
      disabledColor: Color(0xFF424242),
      selectedColor: primaryLight,
      secondarySelectedColor: secondaryLight,
      labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      brightness: Brightness.dark,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: Color(0xFF001A41),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: primaryLight,
      unselectedItemColor: Color(0xFF808080),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: headlineMedium.copyWith(color: Color(0xFFE8E8E8)),
      contentTextStyle: bodyMedium.copyWith(color: Color(0xFFB3B3B3)),
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
