import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/models/json_stats.dart';
import '../services/json_fixer_service.dart';

part 'json_editor_provider.g.dart';

// === Service Provider ===

@Riverpod(keepAlive: true)
JsonFixerService jsonFixerService(Ref ref) {
  return JsonFixerService();
}

// === State Providers ===

/// 輸入文字 Provider
@Riverpod(keepAlive: true)
class InputText extends _$InputText {
  @override
  String build() => '';

  void update(String text) {
    state = text;
  }
}

/// 格式化模式
enum FormatMode { fix, format, minify }

/// 格式化模式 Provider
@Riverpod(keepAlive: true)
class FormatModeState extends _$FormatModeState {
  @override
  FormatMode build() => FormatMode.fix;

  void update(FormatMode mode) {
    state = mode;
  }
}

/// 輸出文字 Provider (即時修正 JSON，用於樹狀結構)
@Riverpod(keepAlive: true)
String outputText(Ref ref) {
  final input = ref.watch(inputTextProvider);
  final service = ref.watch(jsonFixerServiceProvider);

  if (input.trim().isEmpty) return '';

  try {
    return service.fixJson(input);
  } catch (e) {
    return '';
  }
}

/// 縮排設定 Provider
@Riverpod(keepAlive: true)
class IndentSize extends _$IndentSize {
  @override
  int build() => 2;

  void update(int size) {
    state = size;
  }
}

/// 輸入字體大小 Provider
@Riverpod(keepAlive: true)
class InputFontSize extends _$InputFontSize {
  @override
  double build() => 14.0;

  void update(double size) {
    state = size;
  }

  void increase() {
    if (state < 24) {
      update(state + 2);
    }
  }

  void decrease() {
    if (state > 10) {
      update(state - 2);
    }
  }
}

/// 輸出字體大小 Provider
@Riverpod(keepAlive: true)
class OutputFontSize extends _$OutputFontSize {
  @override
  double build() => 14.0;

  void update(double size) {
    state = size;
  }

  void increase() {
    if (state < 24) {
      update(state + 2);
    }
  }

  void decrease() {
    if (state > 10) {
      update(state - 2);
    }
  }
}

/// 錯誤訊息 Provider
@Riverpod(keepAlive: true)
class ErrorMessage extends _$ErrorMessage {
  @override
  String? build() => null;

  void update(String? message) {
    state = message;
  }

  void clear() => update(null);
}

/// JSON 統計資訊 Provider
@Riverpod(keepAlive: true)
JsonStats jsonStats(Ref ref) {
  final output = ref.watch(outputTextProvider);
  final service = ref.watch(jsonFixerServiceProvider);
  return service.getStats(output);
}

/// JSON 驗證結果 Provider
@Riverpod(keepAlive: true)
(bool, String?) jsonValidation(Ref ref) {
  final output = ref.watch(outputTextProvider);
  if (output.isEmpty) return (false, null);
  final service = ref.watch(jsonFixerServiceProvider);
  return service.validateJson(output);
}

// === Editor Notifier ===

/// JSON 編輯器操作類
@Riverpod(keepAlive: true)
class JsonEditor extends _$JsonEditor {
  @override
  void build() {}

  void updateInput(String text) {
    ref.read(inputTextProvider.notifier).update(text);
  }

  void setFormatMode(FormatMode mode) {
    ref.read(formatModeStateProvider.notifier).update(mode);
  }

  void setIndentSize(int size) {
    ref.read(indentSizeProvider.notifier).update(size);
  }

  void increaseInputFontSize() {
    ref.read(inputFontSizeProvider.notifier).increase();
  }

  void decreaseInputFontSize() {
    ref.read(inputFontSizeProvider.notifier).decrease();
  }

  void increaseOutputFontSize() {
    ref.read(outputFontSizeProvider.notifier).increase();
  }

  void decreaseOutputFontSize() {
    ref.read(outputFontSizeProvider.notifier).decrease();
  }

  void clear() {
    ref.read(inputTextProvider.notifier).update('');
    ref.read(errorMessageProvider.notifier).clear();
  }

  /// 修復 JSON 並更新左邊輸入區
  void fixJson() {
    final input = ref.read(inputTextProvider);
    if (input.trim().isEmpty) return;

    final service = ref.read(jsonFixerServiceProvider);
    try {
      final fixed = service.fixJson(input);
      ref.read(inputTextProvider.notifier).update(fixed);
      ref.read(errorMessageProvider.notifier).clear();
    } catch (e) {
      ref.read(errorMessageProvider.notifier).update(e.toString());
    }
  }
}
