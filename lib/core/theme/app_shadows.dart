import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 應用程式陰影定義
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get low => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get glowAccent => [
        BoxShadow(
          color: AppColors.accentPrimary.withValues(alpha: 0.3),
          blurRadius: 12,
          spreadRadius: -2,
        ),
      ];
}
