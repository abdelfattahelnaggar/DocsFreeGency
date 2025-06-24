import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

import 'section_card_widget.dart';

class TeamInfoSection extends StatelessWidget {
  final TextEditingController teamNameController;
  final TextEditingController descriptionController;

  const TeamInfoSection({
    super.key,
    required this.teamNameController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCardWidget(
      title: context.tr('edit_profile.team_info'),
      children: [
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context, text: context.tr('edit_profile.team_name')),
        8.height,
        CustomTextField(
            fillColor: Theme.of(context).colorScheme.surface,
            controller: teamNameController,
            hintText: context.tr('edit_profile.team_name_hint'),
            prefixIcon: Iconsax.people),
        16.height,
        ReusableTextStyleMethods.poppins14BoldMethod(
            context: context,
            text: context.tr('edit_profile.team_description')),
        8.height,
        CustomTextField(
            fillColor: Theme.of(context).colorScheme.surface,
            controller: descriptionController,
            hintText: context.tr('edit_profile.team_description_hint'),
            maxLines: 4),
      ],
    );
  }
}
