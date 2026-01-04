import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

export 'app_colors.dart';
export 'app_gradients.dart';
export 'app_shadows.dart';
export 'app_dimensions.dart';
export 'app_durations.dart';
export 'app_button_styles.dart';

/// 應用程式主題配置
class AppTheme {
  AppTheme._();

  // === 向後兼容的別名 (Backward Compatibility) ===
  // 背景色
  static const Color backgroundDeep = AppColors.backgroundDeep;
  static const Color backgroundBase = AppColors.backgroundBase;
  static const Color backgroundElevated = AppColors.backgroundElevated;
  static const Color backgroundSurface = AppColors.backgroundSurface;

  // 邊框
  static const Color borderSubtle = AppColors.borderSubtle;
  static const Color borderDefault = AppColors.borderDefault;
  static const Color borderHover = AppColors.borderHover;

  // 文字
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textTertiary = AppColors.textTertiary;
  static const Color textMuted = AppColors.textMuted;

  // 強調色
  static const Color accentPrimary = AppColors.accentPrimary;
  static const Color accentLight = AppColors.accentLight;
  static const Color accentDark = AppColors.accentDark;
  static const Color accentSubtle = AppColors.accentSubtle;

  // 功能色
  static const Color successPrimary = AppColors.successPrimary;
  static const Color successSubtle = AppColors.successSubtle;
  static const Color errorPrimary = AppColors.errorPrimary;
  static const Color errorSubtle = AppColors.errorSubtle;
  static const Color infoPrimary = AppColors.infoPrimary;
  static const Color infoSubtle = AppColors.infoSubtle;

  // 按鈕
  static const Color buttonPrimary = AppColors.buttonPrimary;
  static const Color buttonSecondary = AppColors.buttonSecondary;

  // 漸層
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5C878), Color(0xFFE5A54B), Color(0xFFD4942A)],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A1F), Color(0xFF141417)],
  );

  // 陰影
  static List<BoxShadow> get elevationLow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get glowAccent => [
        BoxShadow(
          color: accentPrimary.withValues(alpha: 0.3),
          blurRadius: 12,
          spreadRadius: -2,
        ),
      ];

  // 圓角
  static const double radiusSmall = AppDimensions.radiusSmall;
  static const double radiusMedium = AppDimensions.radiusMedium;
  static const double radiusLarge = AppDimensions.radiusLarge;

  // 動畫
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);

  // 舊版相容
  static const Color editorBackground = backgroundBase;
  static const Color toolbarBackground = backgroundElevated;
  static const Color borderColor = borderDefault;
  static const Color successColor = successPrimary;
  static const Color errorColor = errorPrimary;
  static const Color buttonColor = accentPrimary;
  static const Color buttonHoverColor = accentLight;

  /// Material Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.accentPrimary,
      scaffoldBackgroundColor: AppColors.backgroundBase,
      fontFamily: 'SF Pro Display',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundElevated,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.backgroundSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      dividerColor: AppColors.borderSubtle,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        labelMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 20,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.backgroundSurface,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
