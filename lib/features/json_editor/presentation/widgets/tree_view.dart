import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/json_editor_provider.dart';
import '../../../../shared/theme/app_theme.dart';

class JsonTreeView extends ConsumerWidget {
  final String jsonString;

  const JsonTreeView({super.key, required this.jsonString});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(outputFontSizeProvider);

    if (jsonString.isEmpty) {
      return Container(
        color: AppTheme.backgroundBase,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.code_off_rounded,
                color: AppTheme.textTertiary,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                '沒有可顯示的 JSON',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    try {
      final jsonData = json.decode(jsonString);
      return Container(
        color: AppTheme.backgroundBase,
        child: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 12, top: 16, right: 16, bottom: 16),
            child: _JsonNode(data: jsonData, fontSize: fontSize, path: 'root'),
          ),
        ),
      );
    } catch (e) {
      return Container(
        color: AppTheme.backgroundBase,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.errorSubtle,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: AppTheme.errorPrimary.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppTheme.errorPrimary,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  '無法解析 JSON',
                  style: TextStyle(
                    color: AppTheme.errorPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class _JsonNode extends StatefulWidget {
  final dynamic data;
  final String? keyName;
  final int depth;
  final bool isLast;
  final double fontSize;
  final String path;
  final bool isArrayElement;

  const _JsonNode({
    required this.data,
    this.keyName,
    this.depth = 0,
    this.isLast = true,
    this.fontSize = 13,
    this.path = '',
    this.isArrayElement = false,
  });

  @override
  State<_JsonNode> createState() => _JsonNodeState();
}

class _JsonNodeState extends State<_JsonNode>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.data is Map) {
      return _buildMapNode(widget.data as Map);
    } else if (widget.data is List) {
      return _buildListNode(widget.data as List);
    } else {
      return _buildValueNode(widget.data);
    }
  }

  Widget _buildMapNode(Map data) {
    final entries = data.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader('{', '}', entries.length, 'Object'),
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(entries.length, (index) {
                final e = entries[index];
                final childPath = '${widget.path}.${e.key}';
                return _JsonNode(
                  data: e.value,
                  keyName: e.key.toString(),
                  depth: widget.depth + 1,
                  isLast: index == entries.length - 1,
                  fontSize: widget.fontSize,
                  path: childPath,
                  isArrayElement: false,
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildListNode(List data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader('[', ']', data.length, 'Array'),
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(data.length, (index) {
                final childPath = '${widget.path}[$index]';
                return _JsonNode(
                  data: data[index],
                  keyName: '$index',
                  depth: widget.depth + 1,
                  isLast: index == data.length - 1,
                  fontSize: widget.fontSize,
                  path: childPath,
                  isArrayElement: true,
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(
      String openBracket, String closeBracket, int count, String typeName) {
    final fontSize = widget.fontSize;
    final iconSize = fontSize + 2;
    final badgeFontSize = fontSize - 3;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedRotation(
              turns: _isExpanded ? 0.25 : 0,
              duration: AppTheme.animationFast,
              child: Icon(
                Icons.chevron_right_rounded,
                size: iconSize,
                color: AppTheme.textTertiary,
              ),
            ),
            const SizedBox(width: 4),
            // 陣列 index 顯示（不可點擊高亮）
            if (widget.isArrayElement && widget.keyName != null) ...[
              Text(
                '${widget.keyName}: ',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: fontSize,
                  fontFamily: 'JetBrains Mono, SF Mono, monospace',
                ),
              ),
            ],
            // 物件 key 顯示（可點擊高亮）
            if (!widget.isArrayElement && widget.keyName != null) ...[
              _buildClickableValue(
                '"${widget.keyName}"',
                const Color(0xFF9CDCFE),
                widget.keyName!,
              ),
              Text(
                ': ',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: fontSize,
                ),
              ),
            ],
            Text(
              _isExpanded ? openBracket : '$openBracket...$closeBracket',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: fontSize,
                fontFamily: 'JetBrains Mono, SF Mono, monospace',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.accentSubtle,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$count ${count == 1 ? 'item' : 'items'}',
                style: TextStyle(
                  color: AppTheme.accentPrimary,
                  fontSize: badgeFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueNode(dynamic value) {
    final fontSize = widget.fontSize;
    Color valueColor;
    String displayValue;
    String copyValue;

    if (value is String) {
      valueColor = const Color(0xFFCE9178);
      displayValue = '"$value"';
      copyValue = value;
    } else if (value is num) {
      valueColor = const Color(0xFFB5CEA8);
      displayValue = value.toString();
      copyValue = value.toString();
    } else if (value is bool) {
      valueColor = const Color(0xFF569CD6);
      displayValue = value.toString();
      copyValue = value.toString();
    } else if (value == null) {
      valueColor = const Color(0xFF569CD6);
      displayValue = 'null';
      copyValue = 'null';
    } else {
      valueColor = AppTheme.textSecondary;
      displayValue = value.toString();
      copyValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 陣列 index 顯示（不可點擊高亮）
            if (widget.isArrayElement && widget.keyName != null) ...[
              Text(
                '${widget.keyName}: ',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: fontSize,
                  fontFamily: 'JetBrains Mono, SF Mono, monospace',
                ),
              ),
            ],
            // 物件 key 顯示（可點擊高亮）
            if (!widget.isArrayElement && widget.keyName != null) ...[
              _buildClickableValue(
                '"${widget.keyName}"',
                const Color(0xFF9CDCFE),
                widget.keyName!,
              ),
              Text(
                ': ',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: fontSize,
                ),
              ),
            ],
            // Value（可點擊高亮複製）
            _buildClickableValue(displayValue, valueColor, copyValue),
          ],
        ),
      ),
    );
  }

  /// 建立可點擊、可高亮、可複製的值
  Widget _buildClickableValue(String displayText, Color color, String copyText) {
    return _ClickableValue(
      displayText: displayText,
      color: color,
      copyText: copyText,
      fontSize: widget.fontSize,
      path: widget.path,
    );
  }
}

/// 可點擊高亮複製的值元件
class _ClickableValue extends StatefulWidget {
  final String displayText;
  final Color color;
  final String copyText;
  final double fontSize;
  final String path;

  const _ClickableValue({
    required this.displayText,
    required this.color,
    required this.copyText,
    required this.fontSize,
    required this.path,
  });

  @override
  State<_ClickableValue> createState() => _ClickableValueState();
}

class _ClickableValueState extends State<_ClickableValue> {
  bool _isHovered = false;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.copyText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.successPrimary, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '已複製: ${widget.copyText.length > 50 ? '${widget.copyText.substring(0, 50)}...' : widget.copyText}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.backgroundSurface,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _copyToClipboard(context),
        child: AnimatedContainer(
          duration: AppTheme.animationFast,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.accentSubtle : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: _isHovered
                ? Border.all(color: AppTheme.accentPrimary.withValues(alpha: 0.5))
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.displayText,
                style: TextStyle(
                  color: _isHovered ? AppTheme.accentPrimary : widget.color,
                  fontSize: widget.fontSize,
                  fontFamily: 'JetBrains Mono, SF Mono, monospace',
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (_isHovered) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.content_copy_rounded,
                  size: widget.fontSize - 2,
                  color: AppTheme.accentPrimary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
