import 'dart:convert';

class JsonFixerService {
  /// 修復非標準 JSON（如 Dart Map 格式）轉為標準 JSON
  String fixJson(String input) {
    if (input.trim().isEmpty) return '';

    // 先嘗試直接解析，如果成功就不需要修復
    try {
      final parsed = json.decode(input);
      return const JsonEncoder.withIndent('  ').convert(parsed);
    } catch (_) {
      // 需要修復
    }

    String trimmed = input.trim();

    // 自動補上外層括號
    if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) {
      // 判斷內容類型：如果包含 : 則是物件，否則是陣列
      if (trimmed.contains(':')) {
        trimmed = '{$trimmed}';
      } else {
        trimmed = '[$trimmed]';
      }
    }

    // 使用 tokenizer 方式來修復
    String result = _tokenizeAndFix(trimmed);

    // 移除結尾多餘的逗號 (trailing comma)
    result = _removeTrailingCommas(result);

    // 驗證修復後的 JSON
    try {
      final parsed = json.decode(result);
      return const JsonEncoder.withIndent('  ').convert(parsed);
    } catch (e) {
      throw FormatException('無法修復 JSON: $e\n修復後: $result');
    }
  }

  /// 移除 JSON 中的結尾逗號
  String _removeTrailingCommas(String input) {
    // 移除 ,} 和 ,] 的情況（允許中間有空白）
    String result = input;
    // 持續移除直到沒有變化
    String prev;
    do {
      prev = result;
      result = result.replaceAllMapped(
        RegExp(r',(\s*)([\}\]])'),
        (m) => '${m.group(1)}${m.group(2)}',
      );
    } while (result != prev);
    return result;
  }

  /// 使用狀態機方式解析和修復
  String _tokenizeAndFix(String input) {
    final buffer = StringBuffer();
    int i = 0;

    // 結構字元
    bool isStructuralChar(String c) {
      return c == '{' || c == '}' || c == '[' || c == ']' || c == ':' || c == ',';
    }

    while (i < input.length) {
      final char = input[i];

      // 跳過空白（但只在結構字元之間）
      if (char == ' ' || char == '\t' || char == '\n' || char == '\r') {
        buffer.write(char);
        i++;
        continue;
      }

      // 結構字元直接保留
      if (isStructuralChar(char)) {
        buffer.write(char);
        i++;
        continue;
      }

      // 已有引號的字串 - 保留原樣
      if (char == '"' || char == "'") {
        final quote = char;
        buffer.write('"'); // 統一使用雙引號
        i++;
        while (i < input.length && input[i] != quote) {
          if (input[i] == '\\' && i + 1 < input.length) {
            buffer.write(input[i]);
            buffer.write(input[i + 1]);
            i += 2;
          } else {
            // 處理需要轉義的字元
            if (input[i] == '"' && quote == "'") {
              buffer.write('\\"');
            } else {
              buffer.write(input[i]);
            }
            i++;
          }
        }
        buffer.write('"');
        if (i < input.length) i++; // 跳過結束引號
        continue;
      }

      // 數字開頭 - 檢查是否真的是數字
      if (char == '-' || _isDigit(char)) {
        final numStart = i;
        bool isNumber = true;

        // 嘗試解析數字
        int tempI = i;
        if (input[tempI] == '-') tempI++;

        // 必須有數字
        if (tempI < input.length && _isDigit(input[tempI])) {
          while (tempI < input.length && _isDigit(input[tempI])) {
            tempI++;
          }
          // 小數部分
          if (tempI < input.length && input[tempI] == '.') {
            tempI++;
            while (tempI < input.length && _isDigit(input[tempI])) {
              tempI++;
            }
          }
          // 指數部分
          if (tempI < input.length && (input[tempI] == 'e' || input[tempI] == 'E')) {
            tempI++;
            if (tempI < input.length && (input[tempI] == '+' || input[tempI] == '-')) {
              tempI++;
            }
            while (tempI < input.length && _isDigit(input[tempI])) {
              tempI++;
            }
          }

          // 數字後面必須是結構字元或空白或結束
          if (tempI >= input.length ||
              isStructuralChar(input[tempI]) ||
              input[tempI] == ' ' ||
              input[tempI] == '\t' ||
              input[tempI] == '\n' ||
              input[tempI] == '\r') {
            // 是有效數字
            buffer.write(input.substring(numStart, tempI));
            i = tempI;
            continue;
          }
        }

        // 不是數字，當作一般值處理（繼續往下）
        isNumber = false;
      }

      // 無引號的值（可能包含空格、分號等）
      // 讀取直到遇到結構字元
      final valueStart = i;
      while (i < input.length && !isStructuralChar(input[i])) {
        i++;
      }
      String value = input.substring(valueStart, i).trim();

      if (value.isNotEmpty) {
        // 檢查是否是關鍵字
        if (value == 'true' || value == 'false' || value == 'null') {
          buffer.write(value);
        } else {
          // 檢查是否是純數字
          if (_isValidNumber(value)) {
            buffer.write(value);
          } else {
            // 其他都當字串處理，需要轉義內部的雙引號
            final escaped = value.replaceAll('"', '\\"');
            buffer.write('"$escaped"');
          }
        }
      }
    }

    return buffer.toString();
  }

  /// 檢查是否是有效的 JSON 數字
  bool _isValidNumber(String s) {
    if (s.isEmpty) return false;
    try {
      num.parse(s);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _isDigit(String char) {
    return char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
  }

  bool _isIdentifierStart(String char) {
    final code = char.codeUnitAt(0);
    return (code >= 65 && code <= 90) ||  // A-Z
           (code >= 97 && code <= 122) || // a-z
           char == '_' || char == '\$';
  }

  bool _isIdentifierPart(String char) {
    final code = char.codeUnitAt(0);
    return (code >= 65 && code <= 90) ||  // A-Z
           (code >= 97 && code <= 122) || // a-z
           (code >= 48 && code <= 57) ||  // 0-9
           char == '_' || char == '\$' ||
           char == '-' || char == '.' ||
           char == '@';
  }

  /// 格式化 JSON
  String formatJson(String input, {int indent = 2}) {
    try {
      final parsed = json.decode(input);
      return JsonEncoder.withIndent(' ' * indent).convert(parsed);
    } catch (e) {
      throw FormatException('無效的 JSON: $e');
    }
  }

  /// 壓縮 JSON（移除所有空白）
  String minifyJson(String input) {
    try {
      final parsed = json.decode(input);
      return json.encode(parsed);
    } catch (e) {
      throw FormatException('無效的 JSON: $e');
    }
  }

  /// 驗證 JSON 是否有效
  (bool isValid, String? error) validateJson(String input) {
    if (input.trim().isEmpty) {
      return (false, '輸入為空');
    }
    try {
      json.decode(input);
      return (true, null);
    } catch (e) {
      return (false, e.toString());
    }
  }

  /// 計算 JSON 統計資訊
  JsonStats getStats(String input) {
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
}

class JsonStats {
  final int lineCount;
  final int byteSize;
  final bool isValid;

  const JsonStats({
    required this.lineCount,
    required this.byteSize,
    required this.isValid,
  });

  String get formattedSize {
    if (byteSize < 1024) {
      return '$byteSize B';
    } else if (byteSize < 1024 * 1024) {
      return '${(byteSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(byteSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
