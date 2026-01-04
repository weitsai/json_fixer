import 'dart:convert';
import '../domain/models/json_stats.dart';

/// JSON 修復服務
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
    String result = input;
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

    bool isStructuralChar(String c) {
      return c == '{' || c == '}' || c == '[' || c == ']' || c == ':' || c == ',';
    }

    while (i < input.length) {
      final char = input[i];

      // 跳過空白
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
            if (input[i] == '"' && quote == "'") {
              buffer.write('\\"');
            } else {
              buffer.write(input[i]);
            }
            i++;
          }
        }
        buffer.write('"');
        if (i < input.length) i++;
        continue;
      }

      // 數字開頭 - 檢查是否真的是數字
      if (char == '-' || _isDigit(char)) {
        final numStart = i;

        int tempI = i;
        if (input[tempI] == '-') tempI++;

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
            buffer.write(input.substring(numStart, tempI));
            i = tempI;
            continue;
          }
        }
      }

      // 無引號的值
      final valueStart = i;
      while (i < input.length && !isStructuralChar(input[i])) {
        i++;
      }
      String value = input.substring(valueStart, i).trim();

      if (value.isNotEmpty) {
        if (value == 'true' || value == 'false' || value == 'null') {
          buffer.write(value);
        } else {
          if (_isValidNumber(value)) {
            buffer.write(value);
          } else {
            final escaped = value.replaceAll('"', '\\"');
            buffer.write('"$escaped"');
          }
        }
      }
    }

    return buffer.toString();
  }

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
    if (input.isEmpty) return JsonStats.empty;
    return JsonStats.fromJson(input);
  }
}
