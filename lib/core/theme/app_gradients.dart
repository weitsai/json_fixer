import 'package:flutter/material.dart';

/// 應用程式漸層定義
class AppGradients {
  AppGradients._();

  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5C878), Color(0xFFE5A54B), Color(0xFFD4942A)],
  );

  static const LinearGradient surface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A1F), Color(0xFF141417)],
  );

  static const LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x15FFFFFF), Color(0x05FFFFFF)],
  );

  static LinearGradient accentHover = const LinearGradient(
    colors: [Color(0xFFFAD590), Color(0xFFF5C878)],
  );
}
