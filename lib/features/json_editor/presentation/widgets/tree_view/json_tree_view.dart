import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../providers/json_editor_provider.dart';
import 'json_node.dart';

/// JSON 樹狀結構視圖
class JsonTreeView extends ConsumerWidget {
  final String jsonString;

  const JsonTreeView({super.key, required this.jsonString});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(outputFontSizeProvider);

    if (jsonString.isEmpty) {
      return _buildEmptyState();
    }

    try {
      final jsonData = json.decode(jsonString);
      return Container(
        color: AppTheme.backgroundBase,
        child: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 12, top: 16, right: 16, bottom: 16),
            child: JsonNode(data: jsonData, fontSize: fontSize, path: 'root'),
          ),
        ),
      );
    } catch (e) {
      return _buildErrorState(e);
    }
  }

  Widget _buildEmptyState() {
    return Container(
      color: AppTheme.backgroundBase,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.code_off_rounded,
              color: AppTheme.textTertiary,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
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

  Widget _buildErrorState(Object error) {
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
                error.toString(),
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

