import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/widgets/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isHome: false,
        child: ReusableTextStyleMethods.poppins16BoldMethod(
          context: context,
          text: context.tr('settings'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language section
              Text(
                context.tr('language'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              8.height,
              const LanguageSelector(),

              24.height,

              // Theme section
              Text(
                context.tr('theme'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              8.height,
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSettingItem(
                        context,
                        Icons.light_mode,
                        context.tr('light'),
                        onTap: () {
                          // Set light theme
                        },
                      ),
                      const Divider(),
                      _buildSettingItem(
                        context,
                        Icons.dark_mode,
                        context.tr('dark'),
                        onTap: () {
                          // Set dark theme
                        },
                      ),
                      const Divider(),
                      _buildSettingItem(
                        context,
                        Icons.settings_system_daydream,
                        context.tr('system'),
                        onTap: () {
                          // Set system theme
                        },
                      ),
                    ],
                  ),
                ),
              ),

              24.height,

              // Other settings
              Text(
                context.tr('notifications'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              8.height,
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSettingToggle(
                    context,
                    Icons.notifications,
                    context.tr('notifications'),
                    true,
                    (value) {
                      // Toggle notifications
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon),
            16.width,
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingToggle(
    BuildContext context,
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon),
          16.width,
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
