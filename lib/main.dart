import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_devtools_tracker/riverpod_devtools_tracker.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      observers: [
        // 使用新的自動追蹤器
        // 會自動追蹤所有 Provider 變更並記錄程式碼位置
        RiverpodDevToolsObserver(
          config: TrackerConfig.forPackage(
            'json_fixer',
            // 在 debug 模式下啟用 console 輸出
            enableConsoleOutput: true,
            prettyConsoleOutput: true,
          ),
        ),
      ],
      child: const JsonFixerApp(),
    ),
  );
}
