import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/specific_team_functionality/cubit/specific_team_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/expandable_projects_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/rating_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/specific_team_details_shimmer.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/team_comments_and_rate_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/team_social_links.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/wraped_skills_for_specific_team.dart';
import 'package:freegency_gp/core/shared/widgets/shimmer_loading.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class SpecificTeamProfileBody extends StatelessWidget {
  const SpecificTeamProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final teamArg = ModalRoute.of(context)?.settings.arguments as TeamsModel;
    final theme = Theme.of(context);

    return BlocBuilder<SpecificTeamFunctionalityCubit,
        SpecificTeamFunctionalityState>(
      builder: (context, state) {
        if (state is SpecificTeamFunctionalityLoading) {
          return Scaffold(
            body: TeamDetailsShimmer(theme: theme),
          );
        }

        if (state is SpecificTeamFunctionalityError) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Iconsax.arrow_left_2,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading team data',
                    style: AppTextStyles.poppins16Bold(context),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.error,
                    style: AppTextStyles.poppins14Regular(context),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<SpecificTeamFunctionalityCubit>()
                          .getSpecificTeam(teamArg.id ?? '');
                    },
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        final team =
            (state is SpecificTeamFunctionalityLoaded) ? state.team : teamArg;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Iconsax.arrow_left_2,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                expandedHeight: 220.0.h,
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double collapsePct =
                        (constraints.maxHeight - kToolbarHeight) /
                            (220.0 - kToolbarHeight);
                    final bool isCollapsed = collapsePct < 0.5;

                    return FlexibleSpaceBar(
                      centerTitle: isCollapsed,
                      titlePadding: EdgeInsets.only(
                        left: isCollapsed ? 0 : 16.0,
                        bottom: 16.0,
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: isCollapsed ? 30.0 : 40.0,
                            width: isCollapsed ? 30.0 : 40.0,
                            margin: const EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  team.logo ??
                                      'https://th.bing.com/th/id/OIP.GHGGLYe7gDfZUzF_tElxiQHaHa?rs=1&pid=ImgDetMain',
                                ),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                          ),
                          Text(
                            team.name ?? 'Team Name',
                            style: isCollapsed
                                ? AppTextStyles.poppins16Regular(context)
                                : AppTextStyles.poppins16Bold(context),
                          ),
                        ],
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Show shimmer while loading image
                          CachedNetworkImage(
                            imageUrl: team.logo ??
                                'https://th.bing.com/th/id/OIP.GHGGLYe7gDfZUzF_tElxiQHaHa?rs=1&pid=ImgDetMain',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => ShimmerLoading(
                              child: Container(
                                color: theme.colorScheme.surface,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          // Blur overlay
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Content below the app bar
              SliverToBoxAdapter(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating section
                        RatingSection(team: team),

                        SizedBox(height: 16.h),

                        // Projects count heading
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              context.tr('projects'),
                              style: AppTextStyles.poppins16Bold(context)!
                                  .copyWith(
                                fontSize: 40.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${team.projects?.length ?? 0}',
                              style: AppTextStyles.poppins16Bold(context)!
                                  .copyWith(
                                fontSize: 40.sp,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // About Us section
                        Text(
                          context.tr('about_us'),
                          style: AppTextStyles.poppins16Bold(context),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          team.about ?? '',
                          style: AppTextStyles.poppins14Regular(context),
                        ),
                        SizedBox(height: 16.h),

                        // Social Links Section
                        if ((team.socialMediaLinks ?? []).isNotEmpty)
                          TeamSocialLinks(team: team),

                        SizedBox(height: 16.h),
                        WrapSkills(team: team),

                        SizedBox(height: 16.h),

                        // Expandable Projects Section
                        ExpandableProjectsSection(
                          team: team,
                          state: state,
                        ),

                        SizedBox(height: 24.h),

                        // Team Reviews Section
                        TeamCommentsAndRateSection(team: team),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
