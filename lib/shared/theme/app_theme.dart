import 'package:flutter/material.dart';

class AppTheme {
  // === 主要色彩系統 ===
  // 深色背景層次
  static const Color backgroundDeep = Color(0xFF0D0D0F);
  static const Color backgroundBase = Color(0xFF141417);
  static const Color backgroundElevated = Color(0xFF1A1A1F);
  static const Color backgroundSurface = Color(0xFF212128);

  // 邊框與分隔線
  static const Color borderSubtle = Color(0xFF2A2A32);
  static const Color borderDefault = Color(0xFF35353F);
  static const Color borderHover = Color(0xFF45454F);

  // 文字色彩
  static const Color textPrimary = Color(0xFFF0F0F2);
  static const Color textSecondary = Color(0xFFA0A0A8);
  static const Color textTertiary = Color(0xFF606068);
  static const Color textMuted = Color(0xFF48484F);

  // === 強調色 - 琥珀金系列 ===
  static const Color accentPrimary = Color(0xFFE5A54B);
  static const Color accentLight = Color(0xFFF5C878);
  static const Color accentDark = Color(0xFFB8832E);
  static const Color accentSubtle = Color(0x20E5A54B);

  // === 功能色 ===
  static const Color successPrimary = Color(0xFF4ADE80);
  static const Color successSubtle = Color(0x204ADE80);
  static const Color errorPrimary = Color(0xFFEF4444);
  static const Color errorSubtle = Color(0x20EF4444);
  static const Color infoPrimary = Color(0xFF60A5FA);
  static const Color infoSubtle = Color(0x2060A5FA);

  // === 按鈕色彩 ===
  static const Color buttonPrimary = Color(0xFFE5A54B);
  static const Color buttonSecondary = Color(0xFF2D2D35);
  static const Color buttonTertiary = Color(0xFF60A5FA);
  static const Color buttonSuccess = Color(0xFF22C55E);

  // === 漸層 ===
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

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x15FFFFFF), Color(0x05FFFFFF)],
  );

  // === 陰影 ===
  static List<BoxShadow> get elevationLow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevationMedium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get glowAccent => [
        BoxShadow(
          color: accentPrimary.withValues(alpha: 0.3),
          blurRadius: 12,
          spreadRadius: -2,
        ),
      ];

  // === 圓角 ===
  static const double radiusSmall = 6;
  static const double radiusMedium = 10;
  static const double radiusLarge = 14;

  // === 間距 ===
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;

  // === 動畫時間 ===
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);

  // === 舊版相容 ===
  static const Color editorBackground = backgroundBase;
  static const Color toolbarBackground = backgroundElevated;
  static const Color borderColor = borderDefault;
  static const Color successColor = successPrimary;
  static const Color errorColor = errorPrimary;
  static const Color buttonColor = accentPrimary;
  static const Color buttonHoverColor = accentLight;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: accentPrimary,
      scaffoldBackgroundColor: backgroundBase,
      fontFamily: 'SF Pro Display',
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundElevated,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardTheme(
        color: backgroundSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: const BorderSide(color: borderSubtle),
        ),
      ),
      dividerColor: borderSubtle,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        labelMedium: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 20,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: backgroundSurface,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// === 自訂元件樣式 ===
class AppButtonStyle {
  static ButtonStyle primary({bool isSmall = false}) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppTheme.accentLight;
        }
        if (states.contains(WidgetState.pressed)) {
          return AppTheme.accentDark;
        }
        return AppTheme.accentPrimary;
      }),
      foregroundColor: WidgetStateProperty.all(AppTheme.backgroundDeep),
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 20,
        vertical: isSmall ? 8 : 12,
      )),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      )),
      elevation: WidgetStateProperty.all(0),
      textStyle: WidgetStateProperty.all(TextStyle(
        fontSize: isSmall ? 12 : 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      )),
    );
  }

  static ButtonStyle secondary({bool isSmall = false}) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppTheme.borderDefault;
        }
        return AppTheme.buttonSecondary;
      }),
      foregroundColor: WidgetStateProperty.all(AppTheme.textPrimary),
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 20,
        vertical: isSmall ? 8 : 12,
      )),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        side: const BorderSide(color: AppTheme.borderDefault),
      )),
      elevation: WidgetStateProperty.all(0),
      textStyle: WidgetStateProperty.all(TextStyle(
        fontSize: isSmall ? 12 : 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      )),
    );
  }

  static ButtonStyle ghost() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppTheme.borderSubtle;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.all(AppTheme.textSecondary),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      )),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      )),
      elevation: WidgetStateProperty.all(0),
    );
  }
}
