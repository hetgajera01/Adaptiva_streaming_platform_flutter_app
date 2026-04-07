import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global theme configuration for PulseStream
/// Color palette inspired by TATA brand (matching internal_exam_app)
class AppTheme {
  // ================= 🎨 PRIMARY COLORS =================
  static const Color primaryColor = Color(0xFF003087); // TATA Blue
  static const Color primaryLight = Color(0xFF141929); // Dark Card
  static const Color primaryDark = Color(0xFF0A0E1A); // Darkest Background
  static const Color primaryVariant = Color(0xFF1C2338); // Surface

  // ================= 🎨 SECONDARY COLORS =================
  static const Color secondaryColor = Color(0xFF141929); // Card Background
  static const Color secondaryLight = Color(0xFF1C2338); // Surface
  static const Color secondaryDark = Color(0xFF0A0E1A); // Dark Background

  // ================= 🎨 ACCENT & BRAND COLORS =================
  static const Color accentColor = Color(0xFFF5A623); // Gold Accent
  static const Color successColor = Color(0xFF4CAF82); // Emerald Green
  static const Color warningColor = Color(0xFFFF8A50); // Warning Orange
  static const Color errorColor = Color(0xFFFF5C5C); // Red
  static const Color infoColor = Color(0xFF2196F3); // Blue

  // ================= 🎨 NEUTRAL COLORS =================
  static const Color backgroundColor = Color(0xFF0A0E1A); // Dark Background
  static const Color surfaceColor = Color(0xFF141929); // Card / Surface
  static const Color dividerColor = Color(0xFF1C2338); // Divider
  static const Color shadowColor = Color(0x1A000000); // Shadow

  // ================= 🎨 TEXT COLORS =================
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFB0BAD3); // Light Blue-Gray
  static const Color textTertiary = Color(0xFF8492B4); // Cool Gray
  static const Color textHint = Color(0xFF5E6B8A); // Medium Gray

  // ================= 🖋 TYPOGRAPHY CONFIGURATION =================
  static const String fontFamily = 'Poppins';
  static const String fontFamilyAlt = 'Poppins';

  // Display styles for streaming platform headers
  static final TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static final TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    height: 1.25,
  );

  static final TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  // Headline styles for content titles
  static final TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );

  static final TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static final TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.45,
  );

  // Title styles for subsections
  static final TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static final TextStyle titleMedium = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static final TextStyle titleSmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Body text styles for content
  static final TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static final TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label styles for buttons and tags
  static final TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static final TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static final TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // ================= 🌙 LIGHT THEME =================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: textPrimary,
      onSecondary: primaryDark,
      onSurface: textPrimary,
      tertiary: accentColor,
      onTertiary: primaryDark,
      outline: textTertiary,
      outlineVariant: textHint,
    ),

    // Scaffold
    scaffoldBackgroundColor: backgroundColor,
    cardColor: surfaceColor,

    // Typography
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textPrimary),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textPrimary,
        disabledBackgroundColor: textHint,
        disabledForegroundColor: textTertiary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        side: const BorderSide(color: accentColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
      hintStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
      errorStyle: GoogleFonts.poppins(color: errorColor, fontSize: 11),
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
      margin: const EdgeInsets.all(0),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: primaryVariant,
      disabledColor: textHint,
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle: GoogleFonts.poppins(color: textPrimary, fontSize: 12),
      brightness: Brightness.dark,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: primaryDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: GoogleFonts.poppins(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.poppins(
        color: textSecondary,
        fontSize: 14,
      ),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryVariant,
      contentTextStyle: GoogleFonts.poppins(color: textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceColor,
      modalBackgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),

    // ListTile Theme
    listTileTheme: const ListTileThemeData(
      textColor: textPrimary,
      iconColor: textPrimary,
    ),

    // Divider
    dividerColor: primaryVariant,
  );

  // ================= 🌙 DARK THEME =================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: textPrimary,
      onSecondary: primaryDark,
      onSurface: textPrimary,
      tertiary: accentColor,
      onTertiary: primaryDark,
      outline: textTertiary,
      outlineVariant: textHint,
    ),

    // Scaffold
    scaffoldBackgroundColor: backgroundColor,
    cardColor: surfaceColor,

    // Typography
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textPrimary),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textPrimary,
        disabledBackgroundColor: textHint,
        disabledForegroundColor: textTertiary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        side: const BorderSide(color: accentColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
      hintStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
      errorStyle: GoogleFonts.poppins(color: errorColor, fontSize: 11),
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
      margin: const EdgeInsets.all(0),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: primaryVariant,
      disabledColor: textHint,
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle: GoogleFonts.poppins(color: textPrimary, fontSize: 12),
      brightness: Brightness.dark,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: primaryDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: GoogleFonts.poppins(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.poppins(
        color: textSecondary,
        fontSize: 14,
      ),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryVariant,
      contentTextStyle: GoogleFonts.poppins(color: textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceColor,
      modalBackgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),

    // ListTile Theme
    listTileTheme: const ListTileThemeData(
      textColor: textPrimary,
      iconColor: textPrimary,
    ),

    // Divider
    dividerColor: primaryVariant,
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
      return const EdgeInsets.all(16);
    } else if (isTabletSize(screenWidth)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
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
