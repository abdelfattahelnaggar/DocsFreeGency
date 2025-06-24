import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

import 'section_card_widget.dart';

class SocialLinksSection extends StatelessWidget {
  final TextEditingController linkedinController;
  final TextEditingController githubController;
  final TextEditingController facebookController;
  final TextEditingController websiteController;

  const SocialLinksSection({
    super.key,
    required this.linkedinController,
    required this.githubController,
    required this.facebookController,
    required this.websiteController,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCardWidget(
      title: context.tr('edit_profile.social_links'),
      children: [
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: 'Linkedin'),
        8.height,
        CustomTextField(
          fillColor: Theme.of(context).colorScheme.surface,
          controller: linkedinController,
          hintText: context.tr('edit_profile.enter_url_hint'),
          prefixIcon: Iconsax.link,
        ),
        16.height,
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: 'GitHub'),
        8.height,
        CustomTextField(
          fillColor: Theme.of(context).colorScheme.surface,
          controller: githubController,
          hintText: context.tr('edit_profile.enter_url_hint'),
          prefixIcon: Iconsax.code,
        ),
        16.height,
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: 'Facebook'),
        8.height,
        CustomTextField(
          fillColor: Theme.of(context).colorScheme.surface,
          controller: facebookController,
          hintText: context.tr('edit_profile.enter_url_hint'),
          prefixIcon: Iconsax.profile_2user,
        ),
        16.height,
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: 'Website'),
        8.height,
        CustomTextField(
          fillColor: Theme.of(context).colorScheme.surface,
          controller: websiteController,
          hintText: context.tr('edit_profile.enter_url_hint'),
          prefixIcon: Iconsax.global,
        ),
      ],
    );
  }
}
