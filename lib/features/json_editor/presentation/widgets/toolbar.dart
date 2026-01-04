import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../providers/json_editor_provider.dart';
import '../../../../shared/theme/app_theme.dart';

class EditorToolbar extends ConsumerWidget {
  const EditorToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppTheme.surfaceGradient,
        border: const Border(
          bottom: BorderSide(color: AppTheme.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Logo 區域
          _LogoBadge(),
          const SizedBox(width: 24),

          // 分隔線
          _VerticalDivider(),
          const SizedBox(width: 20),

          // 檔案操作
          _IconActionButton(
            icon: Icons.folder_open_rounded,
            tooltip: '開啟檔案',
            onPressed: () => _uploadFile(ref),
          ),
          const SizedBox(width: 8),
          _IconActionButton(
            icon: Icons.save_alt_rounded,
            tooltip: '儲存檔案',
            onPressed: () => _downloadFile(ref, context),
          ),
          const SizedBox(width: 20),

          // 分隔線
          _VerticalDivider(),
          const SizedBox(width: 20),

          // FIX 按鈕
          _FixButton(),

          const Spacer(),

          // 清除按鈕
          _IconActionButton(
            icon: Icons.delete_outline_rounded,
            tooltip: '清除全部',
            onPressed: () => ref.read(jsonEditorProvider.notifier).clear(),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFile(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      ref.read(jsonEditorProvider.notifier).updateInput(content);
    }
  }

  Future<void> _downloadFile(WidgetRef ref, BuildContext context) async {
    final output = ref.read(outputTextProvider);
    if (output.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.textSecondary, size: 18),
              const SizedBox(width: 12),
              const Text('沒有可下載的內容'),
            ],
          ),
          backgroundColor: AppTheme.backgroundSurface,
        ),
      );
      return;
    }

    final result = await FilePicker.platform.saveFile(
      dialogTitle: '儲存 JSON 檔案',
      fileName: 'output.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      final file = File(result);
      await file.writeAsString(output);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: AppTheme.successPrimary, size: 18),
                const SizedBox(width: 12),
                Expanded(child: Text('已儲存至: $result')),
              ],
            ),
            backgroundColor: AppTheme.backgroundSurface,
          ),
        );
      }
    }
  }
}

// === Logo Badge ===
class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        boxShadow: AppTheme.glowAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.data_object_rounded,
            color: AppTheme.backgroundDeep,
            size: 16,
          ),
          const SizedBox(width: 6),
          const Text(
            'JSON Fixer',
            style: TextStyle(
              color: AppTheme.backgroundDeep,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// === 垂直分隔線 ===
class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.borderSubtle.withValues(alpha: 0),
            AppTheme.borderDefault,
            AppTheme.borderSubtle.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

// === Icon 操作按鈕 ===
class _IconActionButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isDestructive;

  const _IconActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  State<_IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<_IconActionButton> {
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

// === 縮排選擇器 ===
class _IndentSelector extends StatelessWidget {
  final int currentIndent;
  final WidgetRef ref;

  const _IndentSelector({required this.currentIndent, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDeep,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '縮排',
              style: TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          for (final size in [2, 3, 4])
            _IndentOption(
              size: size,
              isSelected: size == currentIndent,
              onTap: () =>
                  ref.read(jsonEditorProvider.notifier).setIndentSize(size),
            ),
        ],
      ),
    );
  }
}

class _IndentOption extends StatefulWidget {
  final int size;
  final bool isSelected;
  final VoidCallback onTap;

  const _IndentOption({
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_IndentOption> createState() => _IndentOptionState();
}

class _IndentOptionState extends State<_IndentOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppTheme.animationFast,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.accentPrimary
                : (_isHovered ? AppTheme.borderSubtle : Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${widget.size}',
            style: TextStyle(
              color: widget.isSelected
                  ? AppTheme.backgroundDeep
                  : (_isHovered ? AppTheme.textPrimary : AppTheme.textSecondary),
              fontSize: 12,
              fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// === FIX 按鈕 ===
class _FixButton extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FixButton> createState() => _FixButtonState();
}

class _FixButtonState extends ConsumerState<_FixButton> {
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
          // 呼叫 fixJson 方法，修復並更新左邊輸入區
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_fix_high_rounded,
                size: 16,
                color: AppTheme.backgroundDeep,
              ),
              const SizedBox(width: 8),
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

// === 主要操作按鈕 (金色) ===
class _PrimaryActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<_PrimaryActionButton> {
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
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: AppTheme.animationFast,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: _isPressed
                ? null
                : (_isHovered
                    ? const LinearGradient(
                        colors: [Color(0xFFFAD590), Color(0xFFF5C878)],
                      )
                    : AppTheme.accentGradient),
            color: _isPressed ? AppTheme.accentDark : null,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            boxShadow: _isHovered && !_isPressed ? AppTheme.glowAccent : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: AppTheme.backgroundDeep,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
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

// === 次要操作按鈕 ===
class _SecondaryActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SecondaryActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_SecondaryActionButton> createState() => _SecondaryActionButtonState();
}

class _SecondaryActionButtonState extends State<_SecondaryActionButton> {
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
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: AppTheme.animationFast,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _isPressed
                ? AppTheme.borderDefault
                : (_isHovered ? AppTheme.backgroundSurface : AppTheme.buttonSecondary),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            border: Border.all(
              color: _isHovered ? AppTheme.borderHover : AppTheme.borderDefault,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 15,
                color: _isHovered ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: _isHovered ? AppTheme.textPrimary : AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === 輸出工具列 ===
class OutputToolbar extends ConsumerWidget {
  const OutputToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outputFontSize = ref.watch(outputFontSizeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundElevated,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          // 樹狀結構標籤
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.accentSubtle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_tree_rounded, size: 14, color: AppTheme.accentPrimary),
                SizedBox(width: 5),
                Text(
                  '樹狀結構',
                  style: TextStyle(
                    color: AppTheme.accentPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // 複製按鈕
          _SmallActionButton(
            icon: Icons.copy_rounded,
            label: '複製',
            onPressed: () => _copyOutput(ref, context),
          ),
          const SizedBox(width: 16),

          // 字體大小調整
          _FontSizeControl(
            fontSize: outputFontSize,
            onDecrease: () =>
                ref.read(jsonEditorProvider.notifier).decreaseOutputFontSize(),
            onIncrease: () =>
                ref.read(jsonEditorProvider.notifier).increaseOutputFontSize(),
          ),
        ],
      ),
    );
  }

  void _copyOutput(WidgetRef ref, BuildContext context) {
    final output = ref.read(outputTextProvider);
    if (output.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: output));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: AppTheme.successPrimary, size: 18),
              const SizedBox(width: 12),
              const Text('已複製到剪貼簿'),
            ],
          ),
          backgroundColor: AppTheme.backgroundSurface,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}

// === 視圖切換 ===
class _ViewToggle extends StatelessWidget {
  final bool isJsonView;
  final Function(bool) onToggle;

  const _ViewToggle({required this.isJsonView, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDeep,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewToggleOption(
            icon: Icons.code_rounded,
            label: 'JSON',
            isSelected: isJsonView,
            onTap: () => onToggle(true),
          ),
          _ViewToggleOption(
            icon: Icons.account_tree_rounded,
            label: '樹狀',
            isSelected: !isJsonView,
            onTap: () => onToggle(false),
          ),
        ],
      ),
    );
  }
}

class _ViewToggleOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewToggleOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ViewToggleOption> createState() => _ViewToggleOptionState();
}

class _ViewToggleOptionState extends State<_ViewToggleOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppTheme.animationFast,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.accentPrimary
                : (_isHovered ? AppTheme.borderSubtle : Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: widget.isSelected
                    ? AppTheme.backgroundDeep
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected
                      ? AppTheme.backgroundDeep
                      : AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === 小型操作按鈕 ===
class _SmallActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SmallActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<_SmallActionButton> createState() => _SmallActionButtonState();
}

class _SmallActionButtonState extends State<_SmallActionButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.borderSubtle : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: _isHovered ? AppTheme.accentPrimary : AppTheme.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                widget.label,
                style: TextStyle(
                  color: _isHovered ? AppTheme.textPrimary : AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === 字體大小控制 ===
class _FontSizeControl extends StatelessWidget {
  final double fontSize;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _FontSizeControl({
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

// === 輸入工具列 ===
class InputToolbar extends ConsumerWidget {
  const InputToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputFontSize = ref.watch(inputFontSizeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundElevated,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.infoSubtle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_note_rounded, size: 14, color: AppTheme.infoPrimary),
                SizedBox(width: 5),
                Text(
                  '輸入',
                  style: TextStyle(
                    color: AppTheme.infoPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _FontSizeControl(
            fontSize: inputFontSize,
            onDecrease: () =>
                ref.read(jsonEditorProvider.notifier).decreaseInputFontSize(),
            onIncrease: () =>
                ref.read(jsonEditorProvider.notifier).increaseInputFontSize(),
          ),
        ],
      ),
    );
  }
}
