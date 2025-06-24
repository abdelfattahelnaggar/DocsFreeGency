import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

import 'section_card_widget.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController bioController;

  const PersonalInfoSection({
    super.key,
    required this.nameController,
    required this.bioController,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCardWidget(
      title: context.tr('edit_profile.personal_info'),
      children: [
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: context.tr('edit_profile.your_name')),
        8.height,
        CustomTextField(
            fillColor: Theme.of(context).colorScheme.surface,
            controller: nameController,
            hintText: context.tr('edit_profile.your_name_hint'),
            prefixIcon: Iconsax.user),
        16.height,
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: context.tr('edit_profile.bio')),
        8.height,
        CustomTextField(
            fillColor: Theme.of(context).colorScheme.surface,
            textInputType: TextInputType.multiline,
            controller: bioController,
            hintText: context.tr('edit_profile.bio_hint'),
            maxLines: 5),
      ],
    );
  }
}
