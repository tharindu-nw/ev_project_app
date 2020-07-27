import 'package:flutter/material.dart';

class ColorTheme {
  static const Color loginGradientStart = const Color(0xFF2DE0BB);
  static const Color loginGradientEnd = const Color(0xFF33938C);
  static const Color homeGradientStart = const Color(0xFFFFD346);
  static const Color homeGradientEnd = const Color(0xFFFF944C);
  static const Color bookingGradientEnd = const Color(0xFF589CFF);
  static const Color bookingGradientStart = const Color(0xFF5966FF);
  static const Color themeColor = const Color(0xFF090446);
  static const Color barColor = const Color(0xFF011627);
  static const Color cardBackground = const Color(0xFF2ED1B2);
  static const Color homeBackground = const Color(0xFF2C2C2C);
  static const Color homeText = const Color(0xFF2ED1B2);
  static const Color warningText = const Color(0xFFCB4573);
  static const Color launchBackground = const Color(0xFFEAE963);

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
  static const bookingGradient = LinearGradient(
    colors: [
      bookingGradientEnd,
      bookingGradientStart,
    ],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.clamp,
  );
}
