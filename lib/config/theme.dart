import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sizes {
  static double defaultDesignWidth = 428;
  static double defaultDesignHeight = 926;

  static double get designWidth => defaultDesignWidth.w;
  static double get designHeight => defaultDesignHeight.h;

  static double get rapSize => 18.w;
  static double get rapWidth => designWidth - rapSize.w * 2;
}

class Palette {
  static Color primary = const Color(0xFFe6474b);
  static Color secondary = const Color(0XFF00E4B5);

  static Color kakao = const Color(0xFFFFE500);
  static Color apple = const Color(0xFF1C1C1C);
  static Color google = const Color(0xFFFFFFFF);
}

ThemeData createAppTheme(context) {
  return ThemeData(
    fontFamily: 'GmarketSans',
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Palette.primary,
      secondary: Palette.secondary,
    ),
  );
}
