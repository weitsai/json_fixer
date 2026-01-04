import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/json_editor_provider.dart';
import '../widgets/toolbar.dart';
import '../widgets/input_editor.dart';
import '../widgets/output_viewer.dart';
import '../../../../shared/theme/app_theme.dart';

class JsonEditorPage extends ConsumerWidget {
  const JsonEditorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      body: Column(
        children: [
          // 主工具列
          const EditorToolbar(),

          // 編輯區域
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // 左側輸入區
                  Expanded(
                    child: _EditorPanel(
                      child: const InputEditor(),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 右側輸出區
                  Expanded(
                    child: _EditorPanel(
                      child: const OutputViewer(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 狀態列
          const StatusBar(),
        ],
      ),
    );
  }
}

// === 編輯器面板容器 ===
class _EditorPanel extends StatelessWidget {
  final Widget child;

  const _EditorPanel({required this.child});

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

// === 狀態列 ===
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

// === 狀態指示器 ===
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

// === 統計數據標籤 ===
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
