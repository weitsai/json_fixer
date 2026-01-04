import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// 垂直分隔線元件
class AppVerticalDivider extends StatelessWidget {
  final double height;

  const AppVerticalDivider({
    super.key,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.borderSubtle.withValues(alpha: 0),
            AppTheme.borderDefault,
            AppTheme.borderSubtle.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

