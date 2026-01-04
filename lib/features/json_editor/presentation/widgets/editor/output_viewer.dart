import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../providers/json_editor_provider.dart';
import '../toolbar/output_toolbar.dart';
import '../tree_view/json_tree_view.dart';

/// JSON 輸出檢視器
class OutputViewer extends ConsumerWidget {
  const OutputViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final output = ref.watch(outputTextProvider);

    return Container(
      color: AppTheme.backgroundBase,
      child: Column(
        children: [
          const OutputToolbar(),
          Expanded(
            child: JsonTreeView(jsonString: output),
          ),
        ],
      ),
    );
  }
}

