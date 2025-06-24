import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..loadSettings(context),
      child: Scaffold(
        appBar: CustomAppBar(
          isHome: false,
          child: ReusableTextStyleMethods.poppins16BoldMethod(
              context: context, text: context.tr('settings')),
        ),
        body: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SettingsLoaded) {
              return _buildSettingsContent(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, SettingsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          _buildSettingsSection(
            context,
            children: [
              _buildNavigationItem(context,
                  icon: Iconsax.user,
                  text: context.tr('profile'),
                  onTap: () =>
                      context.read<SettingsCubit>().navigateToProfileEdit()),
              _buildNavigationItem(context,
                  icon: Iconsax.heart,
                  text: context.tr('edit_interests'),
                  onTap: () =>
                      context.read<SettingsCubit>().navigateToEditInterests()),
              _buildSwitchItem(
                context,
                icon: Iconsax.notification,
                text: context.tr('notifications_and_sounds'),
                value: state.settings['notificationsEnabled'] ?? true,
                onChanged: (value) =>
                    context.read<SettingsCubit>().toggleNotifications(value),
              ),
              _buildLanguageDropdown(context, state),
              _buildThemeItem(context, state),
            ],
          ),
          24.height,
          _buildSettingsSection(
            context,
            children: [
              _buildNavigationItem(context,
                  icon: Iconsax.support,
                  text: context.tr('help_and_feedback'),
                  onTap: () => context
                      .read<SettingsCubit>()
                      .navigateToHelpAndFeedback()),
              _buildNavigationItem(context,
                  icon: Iconsax.info_circle,
                  text: context.tr('about_app'),
                  onTap: () =>
                      context.read<SettingsCubit>().navigateToAboutApp()),
              _buildNavigationItem(context,
                  icon: Iconsax.message_question,
                  text: context.tr('contact_developers'),
                  onTap: () => context
                      .read<SettingsCubit>()
                      .navigateToContactDevelopers()),
              _buildNavigationItem(context,
                  icon: Iconsax.logout,
                  text: context.tr('logout'),
                  onTap: () => context.read<SettingsCubit>().logout(),
                  isDestructive: true),
              _buildNavigationItem(context,
                  icon: Iconsax.trash,
                  text: context.tr('delete_account'),
                  onTap: () => context.read<SettingsCubit>().deleteAccount(),
                  isDestructive: true),
            ],
          ),
          24.height,
          Text(
            "Version ${state.settings['appVersion'] ?? '1.0.0'}",
            style: AppTextStyles.poppins12Regular(context)!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context,
      {required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => children[index],
        itemCount: children.length,
      ),
    );
  }

  Widget _buildNavigationItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      bool isDestructive = false}) {
    final color = isDestructive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color),
            16.width,
            Text(text,
                style: AppTextStyles.poppins16Regular(context)!
                    .copyWith(color: color)),
            const Spacer(),
            if (!isDestructive)
              Icon(Icons.arrow_forward_ios,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                  size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface),
          16.width,
          ReusableTextStyleMethods.poppins16RegularMethod(
              context: context, text: text),
          const Spacer(),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context, SettingsLoaded state) {
    // Map language codes to flags and names
    final Map<String, Map<String, String>> languageOptions = {
      'en': {'name': 'English', 'flag': '🇺🇸'},
      'ar': {'name': 'العربية', 'flag': '🇸🇦'},
    };

    final currentLanguage = state.settings['currentLanguage'] ?? 'en';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Iconsax.language_square,
              color: Theme.of(context).colorScheme.onSurface),
          16.width,
          ReusableTextStyleMethods.poppins16RegularMethod(
              context: context, text: context.tr('language')),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentLanguage,
                icon: const SizedBox.shrink(),
                dropdownColor: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                items: languageOptions.keys.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Text(languageOptions[value]!['flag']!),
                        8.width,
                        Text(
                          languageOptions[value]!['name']!,
                          style: AppTextStyles.poppins14Regular(context)!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null && newValue != currentLanguage) {
                    context
                        .read<SettingsCubit>()
                        .changeLanguage(context, newValue);
                  }
                },
                selectedItemBuilder: (BuildContext context) {
                  return languageOptions.keys.map((String value) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(languageOptions[currentLanguage]!['flag']!),
                        8.width,
                        Text(
                          languageOptions[currentLanguage]!['name']!,
                          style:
                              AppTextStyles.poppins14Regular(context)!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        8.width,
                        Icon(
                          Iconsax.arrow_down_1,
                          size: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeItem(BuildContext context, SettingsLoaded state) {
    final isDarkMode = state.settings['isDarkMode'] ?? false;
    return _buildSwitchItem(
      context,
      icon: isDarkMode ? Iconsax.moon : Iconsax.sun_1,
      text: context.tr('dark_mode'),
      value: isDarkMode,
      onChanged: (value) =>
          context.read<SettingsCubit>().toggleTheme(context, value),
    );
  }
}
