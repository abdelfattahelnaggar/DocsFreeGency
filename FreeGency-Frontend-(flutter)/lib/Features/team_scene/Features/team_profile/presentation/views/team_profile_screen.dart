import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/repositories/implement_team_profile_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/view_model/cubit/team_profile_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/widgets/additional_projects_section.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/widgets/profile_header_section.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/widgets/projects_section.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/widgets/skills_section.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/widgets/social_links_section.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/widgets/team_code_display_widget.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class TeamProfileScreen extends StatelessWidget {
  const TeamProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = TeamProfileCubit(
          teamProfileRepo: TeamProfileRepoImplementation(),
        );

        // Ensure data loading starts immediately
        cubit.getMyTeamProfile();
        cubit.getTeamProjects();

        return cubit;
      },
      child: const TeamProfileView(),
    );
  }
}

class TeamProfileView extends StatelessWidget {
  const TeamProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TeamProfileCubit, TeamProfileState>(
        listener: (context, state) {
          // final cubit = context.read<TeamProfileCubit>();

          if (state is TeamProfileSuccess) {
            // Print debug info when team data is loaded
            log('Team data loaded: ${state.team.name}');
            log('Skills: ${state.team.skills?.join(', ') ?? 'None'}');
            log('Rating: ${state.team.averageRating}');
          } else if (state is TeamProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile Error: ${state.errorMessage}')),
            );
          } else if (state is TeamProjectsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Projects Error: ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<TeamProfileCubit>();

          // Show loading indicator only when we have no team data yet and the state is loading
          if ((state is TeamProfileLoading || state is TeamProfileInitial) &&
              cubit.myTeam == null) {
            return const Center(child: AppLoadingIndicator());
          }

          // Show error message only when team data failed to load
          if (state is TeamProfileError && cubit.myTeam == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage),
                  16.height,
                  ElevatedButton(
                    onPressed: () {
                      cubit.getMyTeamProfile();
                      cubit.getTeamProjects();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Print debug info for current state
          cubit.printTeamInfo();

          // If we have team data or successful state
          return RefreshIndicator(
            onRefresh: () async {
              await cubit.getMyTeamProfile();
              await cubit.getTeamProjects();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header with padding
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: const ProfileHeaderSection(),
                  ),

                  // Social Links Section with padding
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: const SocialLinksSection(),
                  ),

                  // Team Code Section with padding
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: const TeamCodeDisplayWidget(),
                  ),

                  // Skills Section with padding
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: const SkillsSection(),
                  ),

                  // Projects Section - no padding (handled internally)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: const ProjectsSection(),
                  ),

                  // Additional Projects (when expanded) - no padding (handled internally)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: const AdditionalProjectsSection(),
                  ),

                  // Bottom padding
                  24.height,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
