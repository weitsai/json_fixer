import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

/// Icon 操作按鈕
class IconActionButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isDestructive;

  const IconActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  State<IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<IconActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      preferBelow: false,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: AppTheme.animationFast,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isHovered
                  ? (widget.isDestructive
                      ? AppTheme.errorSubtle
                      : AppTheme.borderSubtle)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _isHovered
                  ? (widget.isDestructive
                      ? AppTheme.errorPrimary
                      : AppTheme.textPrimary)
                  : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

