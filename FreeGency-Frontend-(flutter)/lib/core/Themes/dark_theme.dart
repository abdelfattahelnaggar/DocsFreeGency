import 'package:flutter/material.dart';
import 'package:freegency_gp/core/Themes/colors.dart';

ThemeData getDarkTheme(TextTheme textTheme) {
  return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: DarkColors.instance.kPrimaryColor,
        onPrimary: DarkColors.instance.kContainerColor,
        secondary: DarkColors.instance.kGrayColor,
        error: Colors.red,
        onError: Colors.white,
        primaryContainer: DarkColors.instance.kContainerColor,
        onPrimaryContainer: DarkColors.instance.kPrimaryColor,
        surface: DarkColors.instance.kBackgroundColor,
        onSurface: DarkColors.instance.kBlackColor,
        onSecondaryContainer: DarkColors.instance.kWhiteColor,
      ),
      textTheme: textTheme,
      scaffoldBackgroundColor: DarkColors.instance.kBackgroundColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: DarkColors.instance.kContainerColor,
        foregroundColor: DarkColors.instance.kBlackColor,
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: DarkColors.instance.kBlackColor),
      ),
      cardTheme: CardTheme(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        color: DarkColors.instance.kContainerColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DarkColors.instance.kContainerColor,
        selectedItemColor: DarkColors.instance.kPrimaryColor,
        unselectedItemColor: DarkColors.instance.kGrayColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
          backgroundColor: DarkColors.instance.kPrimaryColor,
          minimumSize: const Size(double.infinity, 60),
        ),
      ));
}
