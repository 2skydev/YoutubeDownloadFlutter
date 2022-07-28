import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sizes {
  static double defaultDesignWidth = 428;
  static double defaultDesignHeight = 926;

  static double get designWidth => defaultDesignWidth.w;
  static double get designHeight => defaultDesignHeight.h;

  static double get rapSize => 18.w;
  static double get rapWidth => designWidth - rapSize.w * 2;

  static double get bottomSheetRadius => 30.sp;
}

class Palette {
  // theme colors
  static Color primary = const Color(0xFF3f51b5);
  static Color secondary = const Color(0XFF00E4B5);

  // backgrounds
  static Color bg = const Color.fromRGBO(241, 243, 245, 1);

  // texts
  static Color grayText1 = const Color(0xFF4E5867);

  // sns
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
