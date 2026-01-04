import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../providers/json_editor_provider.dart';

/// 狀態列
class StatusBar extends ConsumerWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(jsonStatsProvider);
    final validation = ref.watch(jsonValidationProvider);
    final error = ref.watch(errorMessageProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.backgroundElevated,
        border: const Border(
          top: BorderSide(color: AppTheme.borderSubtle),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 驗證狀態指示器
          _StatusIndicator(
            error: error,
            isValid: validation.$1,
          ),

          const Spacer(),

          // 統計資訊
          if (stats.lineCount > 0) ...[
            _StatBadge(
              icon: Icons.format_list_numbered_rounded,
              label: '${stats.lineCount} 行',
            ),
            const SizedBox(width: 16),
            _StatBadge(
              icon: Icons.data_usage_rounded,
              label: stats.formattedSize,
            ),
          ],
        ],
      ),
    );
  }
}

/// 狀態指示器
class _StatusIndicator extends StatelessWidget {
  final String? error;
  final bool isValid;

  const _StatusIndicator({
    required this.error,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return _buildStatus(
        icon: Icons.error_rounded,
        color: AppTheme.errorPrimary,
        bgColor: AppTheme.errorSubtle,
        text: error!,
        isError: true,
      );
    }

    if (isValid) {
      return _buildStatus(
        icon: Icons.check_circle_rounded,
        color: AppTheme.successPrimary,
        bgColor: AppTheme.successSubtle,
        text: 'Valid JSON',
        isError: false,
      );
    }

    return _buildStatus(
      icon: Icons.radio_button_unchecked_rounded,
      color: AppTheme.textTertiary,
      bgColor: Colors.transparent,
      text: '等待輸入...',
      isError: false,
    );
  }

  Widget _buildStatus({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String text,
    required bool isError,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isError ? 400 : double.infinity),
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// 統計數據標籤
class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppTheme.textTertiary,
          size: 13,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

