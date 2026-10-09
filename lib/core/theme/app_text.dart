import 'package:flutter/material.dart';

class AppText {
  static double scale = 1.0;

  static TextStyle amiri({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontFamily: 'Amiri',
        fontSize: fontSize == null ? null : fontSize * scale,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );

  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontFamily: 'Poppins',
        fontSize: fontSize == null ? null : fontSize * scale,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );
}
