import 'package:flutter/material.dart';
import 'package:freegency_gp/core/Themes/colors.dart';

ThemeData getLightTheme(TextTheme textTheme) {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: LightColors.instance.kPrimaryColor,
      onPrimary: LightColors.instance.kContainerColor,
      secondary: LightColors.instance.kGrayColor,
      error: Colors.red,
      onError: Colors.white,
      primaryContainer: LightColors.instance.kContainerColor,
      onPrimaryContainer: LightColors.instance.kPrimaryColor,
      surface: LightColors.instance.kBackgroundColor,
      onSurface: LightColors.instance.kBlackColor,
      onSecondaryContainer: LightColors.instance.kWhiteColor,
    ),
    textTheme: textTheme,
    scaffoldBackgroundColor: LightColors.instance.kBackgroundColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: LightColors.instance.kContainerColor,
      foregroundColor: LightColors.instance.kBlackColor,
      toolbarHeight: 80,
      iconTheme: IconThemeData(color: LightColors.instance.kWhiteColor),
    ),
    cardTheme: CardTheme(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      color: LightColors.instance.kContainerColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: LightColors.instance.kContainerColor,
      selectedItemColor: LightColors.instance.kPrimaryColor,
      unselectedItemColor: LightColors.instance.kGrayColor,
    ),
  );
}
