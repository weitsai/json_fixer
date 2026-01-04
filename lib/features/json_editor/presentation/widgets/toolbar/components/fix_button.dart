import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../providers/json_editor_provider.dart';

/// FIX JSON 主要按鈕
class FixButton extends ConsumerStatefulWidget {
  const FixButton({super.key});

  @override
  ConsumerState<FixButton> createState() => _FixButtonState();
}

class _FixButtonState extends ConsumerState<FixButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          ref.read(jsonEditorProvider.notifier).fixJson();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: AppTheme.animationFast,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: _isPressed ? null : AppTheme.accentGradient,
            color: _isPressed ? AppTheme.accentDark : null,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            boxShadow: _isHovered && !_isPressed ? AppTheme.glowAccent : null,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_fix_high_rounded,
                size: 16,
                color: AppTheme.backgroundDeep,
              ),
              SizedBox(width: 8),
              Text(
                'FIX JSON',
                style: TextStyle(
                  color: AppTheme.backgroundDeep,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

