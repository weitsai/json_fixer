import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/json_editor/presentation/pages/json_editor_page.dart';

class JsonFixerApp extends StatelessWidget {
  const JsonFixerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Fixer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const JsonEditorPage(),
    );
  }
}
