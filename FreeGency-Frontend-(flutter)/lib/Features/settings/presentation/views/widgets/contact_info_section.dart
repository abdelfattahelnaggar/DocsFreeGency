import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

import 'section_card_widget.dart';

class ContactInfoSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const ContactInfoSection({
    super.key,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCardWidget(
      title: context.tr('edit_profile.contact_info'),
      children: [
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: context.tr('edit_profile.email')),
        8.height,
        CustomTextField(
            fillColor: Theme.of(context).colorScheme.surface,
            controller: emailController,
            hintText: context.tr('edit_profile.email_hint'),
            prefixIcon: Iconsax.direct_right,
            textInputType: TextInputType.emailAddress),
        16.height,
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: context.tr('edit_profile.phone')),
        8.height,
        CustomTextField(
            fillColor: Theme.of(context).colorScheme.surface,
            controller: phoneController,
            hintText: context.tr('edit_profile.phone_hint'),
            prefixIcon: Iconsax.call,
            textInputType: TextInputType.phone),
      ],
    );
  }
}
