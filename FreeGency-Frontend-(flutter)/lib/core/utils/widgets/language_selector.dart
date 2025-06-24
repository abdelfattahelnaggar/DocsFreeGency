import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/localization/app_localization.dart';
import 'package:get/get.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: AppLocalization.getCurrentLanguage(context),
          icon: const Icon(Icons.language),
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'en',
              child: Row(
                children: [
                  Text('🇺🇸'),
                  SizedBox(width: 8),
                  Text('English'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'ar',
              child: Row(
                children: [
                  Text('🇸🇦'),
                  SizedBox(width: 8),
                  Text('العربية'),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              AppLocalization.changeLanguage(context, value);
              Get.updateLocale(Locale(value));
            }
          },
        ),
      ),
    );
  }
}
