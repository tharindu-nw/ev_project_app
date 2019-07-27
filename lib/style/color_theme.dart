import 'package:flutter/material.dart';

class ColorTheme {
  static const Color loginGradientStart = const Color(0xFF2DE0BB);
  static const Color loginGradientEnd = const Color(0xFF33938C);
  static const Color homeGradientStart = const Color(0xFFFABD90);
  static const Color homeGradientEnd = const Color(0xFFFF0061);

  static const loginGradient = LinearGradient(
    colors: [
      loginGradientStart,
      loginGradientEnd,
    ],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.clamp,
  );

  static const homeGradient = LinearGradient(
    colors: [
      homeGradientStart,
      homeGradientEnd,
    ],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.clamp,
  );
}
