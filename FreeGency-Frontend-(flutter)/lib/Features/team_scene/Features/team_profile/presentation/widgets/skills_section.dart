import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/view_model/cubit/team_profile_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamProfileCubit, TeamProfileState>(
        builder: (context, state) {
      final cubit = context.read<TeamProfileCubit>();
      final skills = cubit.myTeam?.skills ?? [];

      if (cubit.myTeam == null && state is! TeamProfileError) {
        return const SizedBox();
      }

      if (skills.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skills section header
            Align(
              alignment: Alignment.centerLeft,
              child: ReusableTextStyleMethods.poppins16RegularMethod(
                  context: context, text: 'Skills'),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  'No skills added yet',
                  style: AppTextStyles.poppins14Regular(context),
                ),
              ),
            ),
            16.height,
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skills section header
          Align(
            alignment: Alignment.centerLeft,
            child: ReusableTextStyleMethods.poppins16RegularMethod(
                context: context, text: 'Skills'),
          ),
          // Skills chips
          Wrap(
            spacing: 8.w,
            runSpacing: 12.h,
            children: skills
                .map((skill) => IntrinsicWidth(
                      child: Container(
                        height: 32.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            skill,
                            style: AppTextStyles.poppins12Regular(context)!
                                .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          16.height,
        ],
      );
    });
  }
}
