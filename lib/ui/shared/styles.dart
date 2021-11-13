

import 'package:flutter/material.dart';

class FontSizes {
  static double get scale => 1;
  static double get s10 => 10 * scale;
  static double get s11 => 11 * scale;
  static double get s12 => 12 * scale;
  static double get s14 => 14 * scale;
  static double get s16 => 16 * scale;
  static double get s18 => 18 * scale;
  static double get s20 => 20 * scale;
  static double get s22 => 22 * scale;
  static double get s24 => 24 * scale;
}

class TextStyles {
  static const TextStyle defaultStyle = const TextStyle( fontWeight: FontWeight.w400, height: 1);

  static TextStyle get h1 => defaultStyle.copyWith(fontWeight: FontWeight.w600, fontSize: FontSizes.s24, letterSpacing: -1, height: 1.17);
  static TextStyle get h2 => h1.copyWith(fontSize: FontSizes.s20, letterSpacing: -.5, height: 1.16);
  static TextStyle get h3 => h1.copyWith(fontSize: FontSizes.s16, letterSpacing: -.05, height: 1.29);
  static TextStyle get title1 => defaultStyle.copyWith(fontWeight: FontWeight.bold, fontSize: FontSizes.s16, height: 1.31);
  static TextStyle get title2 => title1.copyWith(fontWeight: FontWeight.w500, fontSize: FontSizes.s14, height: 1.36);
  static TextStyle get body1 => defaultStyle.copyWith(fontWeight: FontWeight.normal, fontSize: FontSizes.s14, height: 1.71);
  static TextStyle get body2 => body1.copyWith(fontSize: FontSizes.s12, height: 1.5, letterSpacing: .2);
  static TextStyle get body3 => body1.copyWith(fontSize: FontSizes.s12, height: 1.5, fontWeight: FontWeight.bold);
  static TextStyle get caption => defaultStyle.copyWith(fontWeight: FontWeight.w500, fontSize: FontSizes.s11, height: 1.36);
}