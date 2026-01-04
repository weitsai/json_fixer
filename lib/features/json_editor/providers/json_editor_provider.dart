import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/json_fixer_service.dart';

// JsonFixerService Provider
final jsonFixerServiceProvider = Provider<JsonFixerService>((ref) {
  return JsonFixerService();
});

// 輸入文字 Provider
final inputTextProvider = StateProvider<String>((ref) => '');

// 格式化模式 Provider
enum FormatMode { fix, format, minify }
final formatModeProvider = StateProvider<FormatMode>((ref) => FormatMode.fix);

// 輸出文字 Provider (即時修正 JSON，用於樹狀結構)
final outputTextProvider = Provider<String>((ref) {
  final input = ref.watch(inputTextProvider);
  final service = ref.watch(jsonFixerServiceProvider);

  if (input.trim().isEmpty) return '';

  try {
    final result = service.fixJson(input);
    return result;
  } catch (e) {
    // 解析失敗時返回空字串，樹狀結構會顯示錯誤訊息
    return '';
  }
});

// 縮排設定 Provider
final indentSizeProvider = StateProvider<int>((ref) => 2);

// 輸入字體大小 Provider
final inputFontSizeProvider = StateProvider<double>((ref) => 14.0);

// 輸出字體大小 Provider
final outputFontSizeProvider = StateProvider<double>((ref) => 14.0);

// 錯誤訊息 Provider
final errorMessageProvider = StateProvider<String?>((ref) => null);

// JSON 統計資訊 Provider
final jsonStatsProvider = Provider<JsonStats>((ref) {
  final output = ref.watch(outputTextProvider);
  final service = ref.watch(jsonFixerServiceProvider);
  return service.getStats(output);
});

// JSON 驗證結果 Provider
final jsonValidationProvider = Provider<(bool, String?)>((ref) {
  final output = ref.watch(outputTextProvider);
  if (output.isEmpty) return (false, null);
  final service = ref.watch(jsonFixerServiceProvider);
  return service.validateJson(output);
});

// 操作類
class JsonEditorNotifier extends Notifier<void> {
  @override
  void build() {}

  void updateInput(String text) {
    ref.read(inputTextProvider.notifier).state = text;
  }

  void setFormatMode(FormatMode mode) {
    ref.read(formatModeProvider.notifier).state = mode;
  }

  void setIndentSize(int size) {
    ref.read(indentSizeProvider.notifier).state = size;
  }

  void increaseInputFontSize() {
    final current = ref.read(inputFontSizeProvider);
    if (current < 24) {
      ref.read(inputFontSizeProvider.notifier).state = current + 2;
    }
  }

  void decreaseInputFontSize() {
    final current = ref.read(inputFontSizeProvider);
    if (current > 10) {
      ref.read(inputFontSizeProvider.notifier).state = current - 2;
    }
  }

  void increaseOutputFontSize() {
    final current = ref.read(outputFontSizeProvider);
    if (current < 24) {
      ref.read(outputFontSizeProvider.notifier).state = current + 2;
    }
  }

  void decreaseOutputFontSize() {
    final current = ref.read(outputFontSizeProvider);
    if (current > 10) {
      ref.read(outputFontSizeProvider.notifier).state = current - 2;
    }
  }

  void clear() {
    ref.read(inputTextProvider.notifier).state = '';
    ref.read(errorMessageProvider.notifier).state = null;
  }

  /// 修復 JSON 並更新左邊輸入區
  void fixJson() {
    final input = ref.read(inputTextProvider);
    if (input.trim().isEmpty) return;

    final service = ref.read(jsonFixerServiceProvider);
    try {
      final fixed = service.fixJson(input);
      ref.read(inputTextProvider.notifier).state = fixed;
      ref.read(errorMessageProvider.notifier).state = null;
    } catch (e) {
      ref.read(errorMessageProvider.notifier).state = e.toString();
    }
  }
}

final jsonEditorProvider = NotifierProvider<JsonEditorNotifier, void>(() {
  return JsonEditorNotifier();
});
