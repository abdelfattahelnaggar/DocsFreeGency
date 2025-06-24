import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/utils/constants/skills_list.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

import '../../cubit/team_profile_cubit.dart';
import 'section_card_widget.dart';

class TeamSkillsSection extends StatefulWidget {
  final List<String> skills;

  const TeamSkillsSection({
    super.key,
    required this.skills,
  });

  @override
  State<TeamSkillsSection> createState() => _TeamSkillsSectionState();
}

class _TeamSkillsSectionState extends State<TeamSkillsSection> {
  late List<String> selectedSkills;

  @override
  void initState() {
    super.initState();
    selectedSkills = List<String>.from(widget.skills);
  }

  void _addSkill(String skill) {
    if (!selectedSkills.contains(skill)) {
      setState(() {
        selectedSkills.add(skill);
      });
      // Call cubit to update team skills
      context.read<TeamProfileCubit>().addSkill(skill);
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      selectedSkills.remove(skill);
    });
    // Call cubit to update team skills
    context.read<TeamProfileCubit>().removeSkill(skill);
  }

  @override
  Widget build(BuildContext context) {
    return SectionCardWidget(
      title: context.tr('edit_profile.team_skills'),
      children: [
        // Dropdown for skill selection
        CustomDropdown<String>.search(
          decoration: CustomDropdownDecoration(
            listItemStyle: AppTextStyles.poppins14Regular(context),
            searchFieldDecoration: SearchFieldDecoration(
              hintStyle: AppTextStyles.poppins14Regular(context),
              textStyle: AppTextStyles.poppins14Regular(context),
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            closedSuffixIcon: const Icon(Icons.keyboard_arrow_down),
            expandedSuffixIcon: const Icon(Icons.keyboard_arrow_up),
            expandedFillColor: Theme.of(context).colorScheme.surface,
            closedFillColor: Theme.of(context).colorScheme.surface,
            hintStyle: AppTextStyles.poppins14Regular(context)!.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
            headerStyle: AppTextStyles.poppins14Regular(context)!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          hintText: context.tr('edit_profile.search_add_skill'),
          searchHintText: context.tr('edit_profile.search_skill'),
          items: skillsList
              .where((skill) => !selectedSkills.contains(skill))
              .toList(),
          onChanged: (selectedItem) {
            if (selectedItem != null) {
              _addSkill(selectedItem);
            }
          },
          overlayHeight: 300.h,
        ),

        if (selectedSkills.isNotEmpty) ...[
          16.height,
          // Skills chips
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: selectedSkills.map((skill) {
              return Chip(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.15),
                avatar: null,
                labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: const BorderSide(style: BorderStyle.none),
                ),
                label: Text(
                  skill,
                  style: AppTextStyles.poppins12Regular(context)!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onDeleted: () => _removeSkill(skill),
              );
            }).toList(),
          ),
        ],

        if (selectedSkills.isEmpty) ...[
          16.height,
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  size: 48,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.4),
                ),
                8.height,
                ReusableTextStyleMethods.poppins14RegularMethod(
                  context: context,
                  text: context.tr('edit_profile.no_skills_yet'),
                ),
                4.height,
                ReusableTextStyleMethods.poppins12RegularMethod(
                  context: context,
                  text: context.tr('edit_profile.add_skills_to_showcase'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
 