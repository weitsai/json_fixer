import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// 編輯器面板容器
class EditorPanel extends StatelessWidget {
  final Widget child;

  const EditorPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundBase,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: AppTheme.elevationLow,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

