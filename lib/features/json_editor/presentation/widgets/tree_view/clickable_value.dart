import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_theme.dart';

/// 可點擊高亮複製的值元件
class ClickableValue extends StatefulWidget {
  final String displayText;
  final Color color;
  final String copyText;
  final double fontSize;

  const ClickableValue({
    super.key,
    required this.displayText,
    required this.color,
    required this.copyText,
    required this.fontSize,
  });

  @override
  State<ClickableValue> createState() => _ClickableValueState();
}

class _ClickableValueState extends State<ClickableValue> {
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

