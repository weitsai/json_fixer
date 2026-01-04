import 'dart:convert';

/// JSON 統計資訊
class JsonStats {
  final int lineCount;
  final int byteSize;
  final bool isValid;

  const JsonStats({
    required this.lineCount,
    required this.byteSize,
    required this.isValid,
  });

  /// 從 JSON 字串計算統計資訊
  factory JsonStats.fromJson(String input) {
    final lines = input.split('\n').length;
    final bytes = utf8.encode(input).length;

    bool isValid = false;
    try {
      json.decode(input);
      isValid = true;
    } catch (_) {}

    return JsonStats(
      lineCount: lines,
      byteSize: bytes,
      isValid: isValid,
    );
  }

  /// 格式化的檔案大小字串
  String get formattedSize {
    if (byteSize < 1024) {
      return '$byteSize B';
    } else if (byteSize < 1024 * 1024) {
      return '${(byteSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(byteSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// 空的統計資訊
  static const empty = JsonStats(
    lineCount: 0,
    byteSize: 0,
    isValid: false,
  );
}
