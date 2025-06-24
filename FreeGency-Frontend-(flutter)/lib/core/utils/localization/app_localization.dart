import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLocalization {
  // Change language method
  static void changeLanguage(BuildContext context, String languageCode) {
    context.setLocale(Locale(languageCode));

    // Also update Get locale for GetX navigation
    Get.updateLocale(Locale(languageCode));
  }

  // Get current language
  static String getCurrentLanguage(BuildContext context) {
    return context.locale.languageCode;
  }

  // Check if the app is in RTL mode
  static bool isRtl(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  // Get translations using Easy Localization's context extension
  static String translate(BuildContext context, String key,
      {List<String>? args, Map<String, String>? namedArgs, String? gender}) {
    return context.tr(key, args: args, namedArgs: namedArgs, gender: gender);
  }
}

// No need for additional extension since EasyLocalization already provides StringTranslateExtension
