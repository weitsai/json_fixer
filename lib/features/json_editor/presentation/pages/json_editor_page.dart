import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/toolbar/editor_toolbar.dart';
import '../widgets/editor/input_editor.dart';
import '../widgets/editor/output_viewer.dart';
import '../widgets/status_bar/status_bar.dart';
import '../widgets/common/editor_panel.dart';

/// JSON 編輯器主頁面
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
              child: const Row(
                children: [
                  // 左側輸入區
                  Expanded(
                    child: EditorPanel(
                      child: InputEditor(),
                    ),
                  ),

                  SizedBox(width: 12),

                  // 右側輸出區
                  Expanded(
                    child: EditorPanel(
                      child: OutputViewer(),
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
