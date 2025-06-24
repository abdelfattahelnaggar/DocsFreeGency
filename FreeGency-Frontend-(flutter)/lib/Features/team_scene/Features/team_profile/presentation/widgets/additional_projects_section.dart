import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_inspiration_view_card.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/view_model/cubit/team_profile_cubit.dart';

class AdditionalProjectsSection extends StatelessWidget {
  const AdditionalProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamProfileCubit, TeamProfileState>(
        buildWhen: (previous, current) =>
            current is TeamProjectsSuccess || current is TeamProfileRefresh,
        builder: (context, state) {
          final cubit = context.read<TeamProfileCubit>();

          // Debug print to verify state changes are being detected
          if (state is TeamProfileRefresh) {
            log(
                'AdditionalProjectsSection received refresh, showAll = ${cubit.showAllProjects}');
          }

          // If there are 2 or fewer projects, or we're not showing all projects, return empty container
          if (cubit.teamProjects.length <= 2 || !cubit.showAllProjects) {
            return const SizedBox.shrink();
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 0.98,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: cubit.teamProjects.length - 2,
            itemBuilder: (context, index) {
              return ProjectInspirationViewCard(
                projectModel: cubit.teamProjects[index + 2],
              );
            },
          );
        });
  }
}
