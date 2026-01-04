import 'package:flutter/material.dart';
import 'features/json_editor/presentation/pages/json_editor_page.dart';
import 'shared/theme/app_theme.dart';

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
