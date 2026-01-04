import 'package:flutter/material.dart';

/// 應用程式色彩系統
class AppColors {
  AppColors._();

  // === 深色背景層次 ===
  static const Color backgroundDeep = Color(0xFF0D0D0F);
  static const Color backgroundBase = Color(0xFF141417);
  static const Color backgroundElevated = Color(0xFF1A1A1F);
  static const Color backgroundSurface = Color(0xFF212128);

  // === 邊框與分隔線 ===
  static const Color borderSubtle = Color(0xFF2A2A32);
  static const Color borderDefault = Color(0xFF35353F);
  static const Color borderHover = Color(0xFF45454F);

  // === 文字色彩 ===
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

  // === 語法高亮色彩 ===
  static const Color syntaxString = Color(0xFFCE9178);
  static const Color syntaxNumber = Color(0xFFB5CEA8);
  static const Color syntaxKeyword = Color(0xFF569CD6);
  static const Color syntaxVariable = Color(0xFF9CDCFE);
  static const Color syntaxType = Color(0xFF4EC9B0);
  static const Color syntaxFunction = Color(0xFFDCDCAA);
}
