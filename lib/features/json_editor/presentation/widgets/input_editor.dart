import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';
import '../../providers/json_editor_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import 'toolbar.dart';

class InputEditor extends ConsumerStatefulWidget {
  const InputEditor({super.key});

  @override
  ConsumerState<InputEditor> createState() => _InputEditorState();
}

class _InputEditorState extends ConsumerState<InputEditor> {
  late CodeLineEditingController _controller;
  bool _isUpdatingFromProvider = false;

  @override
  void initState() {
    super.initState();
    _controller = CodeLineEditingController();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (!_isUpdatingFromProvider) {
      ref.read(jsonEditorProvider.notifier).updateInput(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.watch(inputFontSizeProvider);

    // 監聽外部變更（如上傳檔案）
    ref.listen(inputTextProvider, (previous, next) {
      if (_controller.text != next) {
        _isUpdatingFromProvider = true;
        _controller.text = next;
        _isUpdatingFromProvider = false;
      }
    });

    return Container(
      color: AppTheme.backgroundBase,
      child: Column(
        children: [
          const InputToolbar(),
          Expanded(
            child: CodeEditor(
              controller: _controller,
              style: CodeEditorStyle(
                fontSize: fontSize,
                fontFamily: 'JetBrains Mono, SF Mono, Menlo, Monaco, monospace',
                backgroundColor: AppTheme.backgroundBase,
                codeTheme: CodeHighlightTheme(
                  languages: {'json': CodeHighlightThemeMode(mode: langJson)},
                  theme: _customDarkTheme,
                ),
              ),
              hint: '在此貼上 JSON 或 Dart Map 格式...',
              indicatorBuilder: (context, editingController, chunkController, notifier) {
                return Container(
                  color: AppTheme.backgroundElevated,
                  child: Row(
                    children: [
                      DefaultCodeLineNumber(
                        controller: editingController,
                        notifier: notifier,
                        textStyle: const TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        width: 1,
                        color: AppTheme.borderSubtle,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 自訂的深色主題，配合我們的色彩系統
Map<String, TextStyle> get _customDarkTheme => {
      'root': const TextStyle(
        backgroundColor: AppTheme.backgroundBase,
        color: AppTheme.textPrimary,
      ),
      'comment': TextStyle(color: AppTheme.textTertiary.withValues(alpha: 0.7)),
      'quote': const TextStyle(color: Color(0xFFCE9178)),
      'variable': const TextStyle(color: Color(0xFF9CDCFE)),
      'template-variable': const TextStyle(color: Color(0xFF9CDCFE)),
      'tag': const TextStyle(color: Color(0xFF569CD6)),
      'name': const TextStyle(color: Color(0xFF9CDCFE)),
      'selector-id': const TextStyle(color: Color(0xFF9CDCFE)),
      'selector-class': const TextStyle(color: Color(0xFF9CDCFE)),
      'regexp': const TextStyle(color: Color(0xFFD16969)),
      'deletion': const TextStyle(color: Color(0xFFD16969)),
      'number': const TextStyle(color: Color(0xFFB5CEA8)),
      'built_in': const TextStyle(color: Color(0xFF4EC9B0)),
      'builtin-name': const TextStyle(color: Color(0xFF4EC9B0)),
      'literal': const TextStyle(color: Color(0xFF569CD6)),
      'type': const TextStyle(color: Color(0xFF4EC9B0)),
      'params': const TextStyle(color: Color(0xFF9CDCFE)),
      'meta': const TextStyle(color: Color(0xFF569CD6)),
      'link': const TextStyle(color: Color(0xFF569CD6)),
      'attribute': const TextStyle(color: AppTheme.accentPrimary),
      'string': const TextStyle(color: Color(0xFFCE9178)),
      'symbol': const TextStyle(color: Color(0xFFB5CEA8)),
      'bullet': const TextStyle(color: Color(0xFFB5CEA8)),
      'addition': const TextStyle(color: Color(0xFF4EC9B0)),
      'title': const TextStyle(color: Color(0xFFDCDCAA)),
      'section': const TextStyle(color: Color(0xFFDCDCAA)),
      'keyword': const TextStyle(color: Color(0xFF569CD6)),
      'selector-tag': const TextStyle(color: Color(0xFF569CD6)),
      'emphasis': const TextStyle(fontStyle: FontStyle.italic),
      'strong': const TextStyle(fontWeight: FontWeight.bold),
    };
