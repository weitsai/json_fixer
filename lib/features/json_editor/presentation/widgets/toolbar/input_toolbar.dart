import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../providers/json_editor_provider.dart';
import 'components/font_size_control.dart';

/// 輸入區工具列
class InputToolbar extends ConsumerWidget {
  const InputToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputFontSize = ref.watch(inputFontSizeProvider);

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.infoSubtle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_note_rounded, size: 14, color: AppTheme.infoPrimary),
                SizedBox(width: 5),
                Text(
                  '輸入',
                  style: TextStyle(
                    color: AppTheme.infoPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          FontSizeControl(
            fontSize: inputFontSize,
            onDecrease: () =>
                ref.read(jsonEditorProvider.notifier).decreaseInputFontSize(),
            onIncrease: () =>
                ref.read(jsonEditorProvider.notifier).increaseInputFontSize(),
          ),
        ],
      ),
    );
  }
}

