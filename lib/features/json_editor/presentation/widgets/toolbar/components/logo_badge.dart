import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

/// Logo 標籤元件
class LogoBadge extends StatelessWidget {
  const LogoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        boxShadow: AppTheme.glowAccent,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.data_object_rounded,
            color: AppTheme.backgroundDeep,
            size: 16,
          ),
          SizedBox(width: 6),
          Text(
            'JSON Fixer',
            style: TextStyle(
              color: AppTheme.backgroundDeep,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
