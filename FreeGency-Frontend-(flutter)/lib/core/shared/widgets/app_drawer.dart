import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/freegency_app_logo.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.height,
              Center(
                child: FreeGencyLogo(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 120,
                ),
              ),
              24.height,
              const Divider(),
              16.height,

              // Settings Item
              _buildDrawerItem(
                context,
                icon: Iconsax.setting_2,
                title: context.tr('settings'),
                onTap: () {
                  Get.back(); // Close the drawer first
                  Get.toNamed(AppRoutes.appSettings);
                },
              ),

              const Spacer(),

              // Logout button
              PrimaryCTAButton(
                label: context.tr('logout'),
                onTap: () {
                  Get.offAllNamed(AppRoutes.auth);
                  LocalStorage.clearAllUserData();
                },
              ),
              24.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              16.width,
              ReusableTextStyleMethods.poppins16RegularMethod(
                  context: context, text: title)
            ],
          ),
        ),
      ),
    );
  }
}
