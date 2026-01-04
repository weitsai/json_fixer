import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/vertical_divider.dart';
import '../../../providers/json_editor_provider.dart';
import 'components/logo_badge.dart';
import 'components/icon_action_button.dart';
import 'components/fix_button.dart';

/// 主編輯器工具列
class EditorToolbar extends ConsumerWidget {
  const EditorToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppTheme.surfaceGradient,
        border: const Border(
          bottom: BorderSide(color: AppTheme.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Logo 區域
          const LogoBadge(),
          const SizedBox(width: 24),

          // 分隔線
          const AppVerticalDivider(),
          const SizedBox(width: 20),

          // 檔案操作
          IconActionButton(
            icon: Icons.folder_open_rounded,
            tooltip: '開啟檔案',
            onPressed: () => _uploadFile(ref),
          ),
          const SizedBox(width: 8),
          IconActionButton(
            icon: Icons.save_alt_rounded,
            tooltip: '儲存檔案',
            onPressed: () => _downloadFile(ref, context),
          ),
          const SizedBox(width: 20),

          // 分隔線
          const AppVerticalDivider(),
          const SizedBox(width: 20),

          // FIX 按鈕
          const FixButton(),

          const Spacer(),

          // 清除按鈕
          IconActionButton(
            icon: Icons.delete_outline_rounded,
            tooltip: '清除全部',
            onPressed: () => ref.read(jsonEditorProvider.notifier).clear(),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFile(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      ref.read(jsonEditorProvider.notifier).updateInput(content);
    }
  }

  Future<void> _downloadFile(WidgetRef ref, BuildContext context) async {
    final output = ref.read(outputTextProvider);
    if (output.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.textSecondary, size: 18),
              SizedBox(width: 12),
              Text('沒有可下載的內容'),
            ],
          ),
          backgroundColor: AppTheme.backgroundSurface,
        ),
      );
      return;
    }

    final result = await FilePicker.platform.saveFile(
      dialogTitle: '儲存 JSON 檔案',
      fileName: 'output.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      final file = File(result);
      await file.writeAsString(output);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: AppTheme.successPrimary, size: 18),
                const SizedBox(width: 12),
                Expanded(child: Text('已儲存至: $result')),
              ],
            ),
            backgroundColor: AppTheme.backgroundSurface,
          ),
        );
      }
    }
  }
}

