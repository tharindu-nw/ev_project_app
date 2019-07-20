import 'package:flutter/material.dart';

class ColorTheme {
  static const Color loginGradientStart = const Color(0xFF2DE0BB);
  static const Color loginGradientEnd = const Color(0xFF33938C);

  static const gradient = LinearGradient(
    colors: [
      loginGradientStart,
      loginGradientEnd,
    ],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.clamp,
  );
}
