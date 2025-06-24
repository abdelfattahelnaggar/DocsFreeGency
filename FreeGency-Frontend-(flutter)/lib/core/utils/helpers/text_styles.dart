import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle? _getBaseStyle(BuildContext context, double fontSize,
      FontWeight fontWeight, Color color) {
    final isArabic = context.locale.languageCode == 'ar';

    if (isArabic) {
      return TextStyle(
        fontFamily: 'IBMPlexSansArabic',
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
      );
    }

    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle? poppins20Bold(BuildContext context) {
    return _getBaseStyle(
      context,
      20,
      FontWeight.bold,
      Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle? poppins24Bold(BuildContext context) {
    return _getBaseStyle(
      context,
      24,
      FontWeight.bold,
      Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle? poppins14Regular(BuildContext context) {
    return _getBaseStyle(
      context,
      14,
      FontWeight.normal,
      Theme.of(context).colorScheme.secondary,
    );
  }

  static TextStyle? poppins16Regular(BuildContext context) {
    return _getBaseStyle(
      context,
      16,
      FontWeight.normal,
      Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle? poppins16Bold(BuildContext context) {
    return _getBaseStyle(
      context,
      16,
      FontWeight.bold,
      Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle? poppins12Regular(BuildContext context) {
    return _getBaseStyle(
      context,
      12,
      FontWeight.normal,
      Theme.of(context).colorScheme.secondary,
    );
  }
}
