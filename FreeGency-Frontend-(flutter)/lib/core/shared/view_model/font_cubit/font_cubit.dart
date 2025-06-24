import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FontCubit extends Cubit<TextTheme> {
  FontCubit() : super(_getInitialTextTheme('en'));

  void updateFont(String languageCode) {
    emit(_getInitialTextTheme(languageCode));
  }

  static TextTheme _getInitialTextTheme(String languageCode) {
    final baseTheme = ThemeData.light().textTheme;

    if (languageCode == 'ar') {
      return baseTheme.copyWith(
        displayLarge:
            baseTheme.displayLarge?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        displayMedium:
            baseTheme.displayMedium?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        displaySmall:
            baseTheme.displaySmall?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        headlineLarge:
            baseTheme.headlineLarge?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        headlineMedium:
            baseTheme.headlineMedium?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        headlineSmall:
            baseTheme.headlineSmall?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        titleLarge:
            baseTheme.titleLarge?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        titleMedium:
            baseTheme.titleMedium?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        titleSmall:
            baseTheme.titleSmall?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        bodyLarge:
            baseTheme.bodyLarge?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        bodyMedium:
            baseTheme.bodyMedium?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        bodySmall:
            baseTheme.bodySmall?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        labelLarge:
            baseTheme.labelLarge?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        labelMedium:
            baseTheme.labelMedium?.copyWith(fontFamily: 'IBMPlexSansArabic'),
        labelSmall:
            baseTheme.labelSmall?.copyWith(fontFamily: 'IBMPlexSansArabic'),
      );
    }

    return GoogleFonts.poppinsTextTheme(baseTheme);
  }
}
