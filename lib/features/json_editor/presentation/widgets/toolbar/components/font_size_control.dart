import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

/// 字體大小控制元件
class FontSizeControl extends StatelessWidget {
  final double fontSize;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const FontSizeControl({
    super.key,
    required this.fontSize,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDeep,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FontSizeButton(icon: Icons.remove, onPressed: onDecrease),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${fontSize.toInt()}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          _FontSizeButton(icon: Icons.add, onPressed: onIncrease),
        ],
      ),
    );
  }
}

class _FontSizeButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _FontSizeButton({required this.icon, required this.onPressed});

  @override
  State<_FontSizeButton> createState() => _FontSizeButtonState();
}

class _FontSizeButtonState extends State<_FontSizeButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: AppTheme.animationFast,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.borderSubtle : Colors.transparent,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Icon(
            widget.icon,
            size: 14,
            color: _isHovered ? AppTheme.textPrimary : AppTheme.textTertiary,
          ),
        ),
      ),
    );
  }
}

