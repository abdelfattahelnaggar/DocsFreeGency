import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_inspiration_view_card.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/view_model/cubit/team_profile_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/views/post_project_screen.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamProfileCubit, TeamProfileState>(
      buildWhen: (previous, current) =>
          current is TeamProjectsSuccess || current is TeamProfileRefresh,
      builder: (context, state) {
        final cubit = context.watch<TeamProfileCubit>();

        // Debug print to verify state changes are being detected
        if (state is TeamProfileRefresh) {
          log('ProjectsSection received refresh, showAll = ${cubit.showAllProjects}');
        }

        if (cubit.teamProjects.isEmpty) {
          return _buildEmptyProjectsView(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Projects section header
            Align(
              alignment: Alignment.centerLeft,
              child: ReusableTextStyleMethods.poppins16RegularMethod(
                  context: context, text: 'Projects'),
            ),
            12.height,
            // Projects Grid with actions
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Projects Grid with padding removed
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 0.98,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: cubit.teamProjects.length > 1
                      ? 2
                      : cubit.teamProjects.length,
                  itemBuilder: (context, index) {
                    return ProjectInspirationViewCard(
                      projectModel: cubit.teamProjects[index],
                    );
                  },
                ),

                // Gradient overlay on bottom of projects
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 60.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0),
                          Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: .9),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),

                // Buttons positioned at the bottom edge of projects
                Positioned(
                  bottom: -5.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to add project screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PostProjectScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Add Project'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                        ),
                        16.width,
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<TeamProfileCubit>()
                                .toggleShowAllProjects();

                            // Debug print to verify button press is working
                            log('Toggle button pressed, new value: ${!cubit.showAllProjects}');
                          },
                          icon: Icon(cubit.showAllProjects
                              ? Iconsax.arrow_up_2
                              : Iconsax.arrow_down_1),
                          label: Text(
                              cubit.showAllProjects ? 'View Less' : 'View All'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Space for buttons overflow
            SizedBox(height: 45.h),
          ],
        );
      },
    );
  }

  Widget _buildEmptyProjectsView(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'No projects available',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          16.height,
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add project screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostProjectScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add First Project'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
