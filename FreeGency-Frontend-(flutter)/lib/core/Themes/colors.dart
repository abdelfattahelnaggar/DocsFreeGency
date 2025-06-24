import 'package:flutter/material.dart';

class LightColors {
  // ! Singleton
  LightColors._();
  static LightColors instance = LightColors._();

  Color kBackgroundColor = const Color(0xFFFFFFFF);
  Color kPrimaryColor = const Color(0xFF3A72FF);
  Color kWhiteColor = const Color(0xFFFFFFFF);
  Color kBlackColor = const Color(0xFF000000);
  Color kContainerColor = const Color(0xFFD4E1FF);
  Color kGrayColor = const Color(0xFF6A7180);
}

class DarkColors {
  // ! Singleton
  DarkColors._();
  static DarkColors instance = DarkColors._();

  Color kBackgroundColor = const Color(0xFF1A1A24);
  Color kPrimaryColor = const Color(0xFF745DF5);
  Color kWhiteColor = const Color(0xFF000000);
  Color kBlackColor = const Color(0xFFFAF9FE);
  Color kContainerColor = const Color(0xFF242333);
  Color kGrayColor = const Color(0xFF8C8C91);
}
