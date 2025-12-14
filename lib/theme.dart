import 'package:flutter/material.dart';

final ThemeData defaultTheme = _buildCustomTheme();

class MyColors {
  // الألوان الأساسية - تصميم حديث
  static const Color primaryBlue = Color(0xFF3F8CFF);
  static const Color lightSkyBlue = Color(0xFFA8D5FC);
  static const Color paleSkyBlue = Color(0xFFA3D0FD);
  static const Color softBlue = Color(0xFFADD0F3);
  static const Color lightestBlue = Color(0xFFC2DCEE);

  // الألوان الثانوية
  static const Color darkNavyBlue = Color(0xFF1B3558);
  static const Color mediumBlue = Color(0xFF227A92);
  static const Color accentTeal = Color(0xFF83CBC8);
  static const Color softTeal = Color(0xFF88CDCA);

  // الألوان المساعدة
  static const Color lightRed = Color(0xFFE78771);
  static const Color warmPeach = Color(0xFFF1BDB2);
  static const Color calendarRed = Color(0xFFFADCD4);

  // الألوان المحايدة
  static const Color darkGray = Color(0xFF2D2D2D);
  static const Color mediumGray = Color(0xFF566E8A);
  static const Color lightGray = Color(0xFFA1A1A1);
  static const Color veryLightGray = Color(0xFFF5F7FB);
  static const Color lightWhite = Color(0xFFede7f4);
  static const Color white = Color(0xFFFFFFFF);

  // التدرجات
  static const List<Color> mainGradient = [
    Color.fromARGB(255, 168, 213, 252),
    Color.fromARGB(255, 163, 208, 253),
    Color.fromARGB(255, 173, 208, 243),
    Color.fromARGB(255, 194, 220, 238),
  ];
}

ColorScheme myColorScheme = const ColorScheme(
  primary: MyColors.primaryBlue,
  secondary: MyColors.accentTeal,
  surface: MyColors.white,
  error: MyColors.lightRed,
  onPrimary: MyColors.white,
  onSecondary: MyColors.darkNavyBlue,
  onSurface: MyColors.darkGray,
  onError: MyColors.white,
  brightness: Brightness.light,
);

ThemeData _buildCustomTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: MyColors.primaryBlue,
      foregroundColor: MyColors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: MyColors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Tajawal',
      ),
    ),
    scaffoldBackgroundColor: MyColors.veryLightGray,
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: MyColors.primaryBlue.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: MyColors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: MyColors.primaryBlue,
      foregroundColor: MyColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryBlue,
        foregroundColor: MyColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: MyColors.primaryBlue,
        side: const BorderSide(color: MyColors.primaryBlue, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: MyColors.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MyColors.veryLightGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.lightSkyBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.lightSkyBlue, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.lightRed, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MyColors.lightRed, width: 2),
      ),
      hintStyle: const TextStyle(
        color: MyColors.mediumGray,
        fontFamily: 'Tajawal',
      ),
      labelStyle: const TextStyle(
        color: MyColors.mediumGray,
        fontFamily: 'Tajawal',
      ),
      errorStyle: const TextStyle(
        color: MyColors.lightRed,
        fontFamily: 'Tajawal',
      ),
    ),
    textTheme: _buildCustomTextTheme(base.textTheme),
    primaryTextTheme: _buildCustomTextTheme(base.primaryTextTheme),
    colorScheme: myColorScheme,
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return MyColors.primaryBlue;
        }
        return MyColors.veryLightGray;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return MyColors.primaryBlue;
        }
        return MyColors.lightGray;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return MyColors.primaryBlue;
        }
        return MyColors.lightGray;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return MyColors.primaryBlue.withOpacity(0.5);
        }
        return MyColors.lightGray.withOpacity(0.5);
      }),
    ),
    dividerTheme: const DividerThemeData(
      color: MyColors.lightestBlue,
      thickness: 1,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: TextStyle(
        color: MyColors.darkNavyBlue,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Tajawal',
      ),
      subtitleTextStyle: TextStyle(
        color: MyColors.mediumGray,
        fontSize: 14,
        fontFamily: 'Tajawal',
      ),
      iconColor: MyColors.primaryBlue,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: MyColors.lightGray,
      selectedColor: MyColors.primaryBlue,
      labelStyle: const TextStyle(
        color: MyColors.white,
        fontFamily: 'Tajawal',
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        color: MyColors.white,
        fontFamily: 'Tajawal',
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 2,
      shadowColor: MyColors.primaryBlue.withOpacity(0.2),
    ),
  );
}

TextTheme _buildCustomTextTheme(TextTheme base) {
  return base
      .copyWith(
        displayLarge: base.displayLarge?.copyWith(
          color: MyColors.darkNavyBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
        ),
        displayMedium: base.displayMedium?.copyWith(
          color: MyColors.darkNavyBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
        ),
        displaySmall: base.displaySmall?.copyWith(
          color: MyColors.darkNavyBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: base.headlineLarge?.copyWith(
          color: MyColors.darkNavyBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: MyColors.darkNavyBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: base.headlineSmall?.copyWith(
          color: MyColors.darkNavyBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: base.titleLarge?.copyWith(
          color: MyColors.darkNavyBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        titleMedium: base.titleMedium?.copyWith(
          color: MyColors.darkNavyBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        titleSmall: base.titleSmall?.copyWith(
          color: MyColors.darkNavyBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          color: MyColors.darkGray,
          fontFamily: 'Tajawal',
          fontSize: 16,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          color: MyColors.mediumGray,
          fontFamily: 'Tajawal',
          fontSize: 14,
        ),
        bodySmall: base.bodySmall?.copyWith(
          color: MyColors.lightGray,
          fontFamily: 'Tajawal',
          fontSize: 12,
        ),
        labelLarge: base.labelLarge?.copyWith(
          color: MyColors.primaryBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelMedium: base.labelMedium?.copyWith(
          color: MyColors.primaryBlue,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w500,
        ),
        labelSmall: base.labelSmall?.copyWith(
          color: MyColors.mediumGray,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w400,
        ),
      )
      .apply(fontFamily: 'Tajawal');
}
