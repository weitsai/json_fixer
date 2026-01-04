import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import 'clickable_value.dart';

/// JSON 樹狀節點元件
class JsonNode extends StatefulWidget {
  final dynamic data;
  final String? keyName;
  final int depth;
  final bool isLast;
  final double fontSize;
  final String path;
  final bool isArrayElement;

  const JsonNode({
    super.key,
    required this.data,
    this.keyName,
    this.depth = 0,
    this.isLast = true,
    this.fontSize = 13,
    this.path = '',
    this.isArrayElement = false,
  });

  @override
  State<JsonNode> createState() => _JsonNodeState();
}

class _JsonNodeState extends State<JsonNode> {
  bool _isExpanded = true;

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
                return JsonNode(
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
                return JsonNode(
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
              ClickableValue(
                displayText: '"${widget.keyName}"',
                color: const Color(0xFF9CDCFE),
                copyText: widget.keyName!,
                fontSize: fontSize,
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
              ClickableValue(
                displayText: '"${widget.keyName}"',
                color: const Color(0xFF9CDCFE),
                copyText: widget.keyName!,
                fontSize: fontSize,
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
            ClickableValue(
              displayText: displayValue,
              color: valueColor,
              copyText: copyValue,
              fontSize: fontSize,
            ),
          ],
        ),
      ),
    );
  }
}

