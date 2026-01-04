import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

/// 按鈕樣式定義
class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle primary({bool isSmall = false}) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppColors.accentLight;
        }
        if (states.contains(WidgetState.pressed)) {
          return AppColors.accentDark;
        }
        return AppColors.accentPrimary;
      }),
      foregroundColor: WidgetStateProperty.all(AppColors.backgroundDeep),
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 20,
        vertical: isSmall ? 8 : 12,
      )),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
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
          return AppColors.borderDefault;
        }
        return AppColors.buttonSecondary;
      }),
      foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 20,
        vertical: isSmall ? 8 : 12,
      )),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        side: const BorderSide(color: AppColors.borderDefault),
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
          return AppColors.borderSubtle;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.all(AppColors.textSecondary),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      )),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      )),
      elevation: WidgetStateProperty.all(0),
    );
  }
}
