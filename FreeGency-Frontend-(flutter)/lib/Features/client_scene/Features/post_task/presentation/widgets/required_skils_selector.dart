import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/view_models/cubits/post_task_from_client_cubit.dart';
import 'package:freegency_gp/core/utils/constants/skills_list.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class RequiredSkillSelector extends StatefulWidget {
  final List<String>? requiredSelectedSkills;
  final Function(String)? onSkillAdded;
  final Function(String)? onSkillRemoved;

  const RequiredSkillSelector({
    super.key,
    this.requiredSelectedSkills,
    this.onSkillAdded,
    this.onSkillRemoved,
  });

  @override
  State<RequiredSkillSelector> createState() => _RequiredSkillSelectorState();
}

class _RequiredSkillSelectorState extends State<RequiredSkillSelector> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Use provided skills list or fall back to cubit for backward compatibility
    List<String> requiredSelectedSkills;

    if (widget.requiredSelectedSkills != null) {
      requiredSelectedSkills = widget.requiredSelectedSkills!;
    } else {
      // Fallback to original behavior for backward compatibility
      final cubit = context.read<PostTaskFromClientCubit>();
      requiredSelectedSkills = cubit.requiredSelectedSkills;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.h.height,
        CustomDropdown<String>.search(
          decoration: CustomDropdownDecoration(
              listItemStyle: AppTextStyles.poppins16Regular(context),
              searchFieldDecoration: SearchFieldDecoration(
                hintStyle: AppTextStyles.poppins14Regular(context),
                textStyle: AppTextStyles.poppins16Regular(context),
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              closedSuffixIcon: const SizedBox(),
              expandedSuffixIcon: const SizedBox(),
              expandedFillColor: Theme.of(context).colorScheme.primaryContainer,
              closedFillColor: Theme.of(context).colorScheme.primaryContainer,
              hintStyle: AppTextStyles.poppins14Regular(context),
              headerStyle: AppTextStyles.poppins14Regular(context)!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
          items: skillsList
              .where((skill) => !requiredSelectedSkills.contains(skill))
              .toList(),
          onChanged: (selectedItem) {
            if (!requiredSelectedSkills.contains(selectedItem)) {
              if (widget.onSkillAdded != null) {
                widget.onSkillAdded!(selectedItem!);
              } else {
                // Fallback to original behavior
                setState(() {
                  requiredSelectedSkills.add(selectedItem!);
                  searchController.text = '';
                });
              }
            }
          },
          overlayHeight: 500.h,
        ),
        8.h.height,
        Wrap(
          spacing: 8.w,
          children: requiredSelectedSkills.map((skill) {
            return Chip(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.20),
              avatar: null,
              labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  side: const BorderSide(
                    style: BorderStyle.none,
                  )),
              label: Text(
                skill,
                style: AppTextStyles.poppins12Regular(context)!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              deleteIcon: Icon(
                Icons.close,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              onDeleted: () {
                if (widget.onSkillRemoved != null) {
                  widget.onSkillRemoved!(skill);
                } else {
                  // Fallback to original behavior
                  setState(() {
                    requiredSelectedSkills.remove(skill);
                  });
                }
              },
            );
          }).toList(),
        ),
        8.h.height,
      ],
    );
  }
}
