import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../providers/json_editor_provider.dart';
import 'components/font_size_control.dart';
import 'components/small_action_button.dart';

/// 輸出區工具列
class OutputToolbar extends ConsumerWidget {
  const OutputToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outputFontSize = ref.watch(outputFontSizeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundElevated,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          // 樹狀結構標籤
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.accentSubtle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_tree_rounded, size: 14, color: AppTheme.accentPrimary),
                SizedBox(width: 5),
                Text(
                  '樹狀結構',
                  style: TextStyle(
                    color: AppTheme.accentPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // 複製按鈕
          SmallActionButton(
            icon: Icons.copy_rounded,
            label: '複製',
            onPressed: () => _copyOutput(ref, context),
          ),
          const SizedBox(width: 16),

          // 字體大小調整
          FontSizeControl(
            fontSize: outputFontSize,
            onDecrease: () =>
                ref.read(jsonEditorProvider.notifier).decreaseOutputFontSize(),
            onIncrease: () =>
                ref.read(jsonEditorProvider.notifier).increaseOutputFontSize(),
          ),
        ],
      ),
    );
  }

  void _copyOutput(WidgetRef ref, BuildContext context) {
    final output = ref.read(outputTextProvider);
    if (output.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: output));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.successPrimary, size: 18),
              SizedBox(width: 12),
              Text('已複製到剪貼簿'),
            ],
          ),
          backgroundColor: AppTheme.backgroundSurface,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}

