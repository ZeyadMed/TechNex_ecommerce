import 'package:flutter/material.dart';
import 'package:e_commerce/core/config/brand/brand_config.dart';

abstract final class AppColors {
  static Color get primaryColor2 => BrandConfig.current.palette.secondary;
  static Color get primaryColor => BrandConfig.current.palette.primary;
  static const Color darkTextColor = Color.fromARGB(255, 36, 38, 77);
  static Color get scaffoldBackground =>
      BrandConfig.current.palette.scaffoldBackground;
  static const Color lightTextColor = Color.fromARGB(255, 226, 226, 226);
  static const Color blackColor = Color(0xff000000);
  static const Color semiBlackColor = Color(0xff242426);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color semiWhiteColor = Color(0xffF5F5F5);
  static const Color semiWhiteColor2 = Color(0xffD9D9D9);
  static const Color semiWhiteColor3 = Color(0xffF5F7FA);
  static const Color greyColor = Color(0xff6e6e6e);
  static const Color greyColor2 = Color(0xff60655C);
  static const Color greyColor3 = Color(0xff808080);
  static const Color greyColor4 = Color(0xffA5A5A9);
  static const Color greyColor5 = Color(0xffB3B3B7);
  static const Color greyColor6 = Color(0xff3C3C43);
  static const Color lightGreyColor = Color(0xffE8EFF1);
  static const Color redColor = Color(0xffB60000);
  static const Color redColor2 = Color(0xffE11F1F);
  static const Color greenColor = Color(0xff16B364);
  static const Color lightGreenColor = Color(0xff008000);
  static const Color darkGreenColor = Color(0xff167F71);
  static const Color lightBlueColor = Color(0xff009DDA);
  static const Color lightBlueColor2 = Color(0xff027DCF);
  static const Color mixedCyanColor = Color(0xff007DD1);
  static const Color mixedLightBlueColor = Color(0xff00B2E1);
  static const Color blueColor = Color(0xff017FD2);
  static final Color? theMixedColors =
      Color.lerp(mixedCyanColor, mixedLightBlueColor, 0.5);
  static const Color hintTextColor = Color(0xff91958E);
  static const Color borderColor = Color(0xffE8EBE6);
  static const Color orangeColor = Color(0xffFF6B00);
  static const Color lightOrangeColor = Color(0xffFFC107);
  static const Color filledColor = Color(0xFFF5F9FF);
  static const Color petrollColor = Color(0xFF003B63);
  static const Color fillColor = Color(0xFFF5F9FF);
}
