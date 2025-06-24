import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/home_tap/cubit/client_home_tap_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/top_teams_section.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:shimmer/shimmer.dart';

class TopTeamsSectionBuilder extends StatefulWidget {
  const TopTeamsSectionBuilder({
    super.key,
  });

  @override
  State<TopTeamsSectionBuilder> createState() => _TopTeamsSectionBuilderState();
}

class _TopTeamsSectionBuilderState extends State<TopTeamsSectionBuilder> {
  bool _isClient = false;
  bool _isGuest = false;
  bool _isTeamMember = false;
  bool _shouldShowContent = false;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    _isClient = await LocalStorage.isClient();
    _isGuest = await LocalStorage.isGuest();
    _isTeamMember = await LocalStorage.isTeamMember();
    _shouldShowContent = _isClient ||
        _isGuest ||
        _isTeamMember; // Show content for both client and guest
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowContent) {
      return _buildShimmerLoading(context);
    }

    try {
      return BlocBuilder<ClientHomeTapCubit, ClientHomeTapState>(
        builder: (context, state) {
          if (state is ClientHomeTapTopRatedLoading ||
              state is ClientHomeTapAllDataLoading) {
            return _buildShimmerLoading(context);
          } else if (state is ClientHomeTapTopRatedFailure) {
            return Center(child: Text(state.errMessage));
          } else if (state is ClientHomeTapTopRatedSuccess) {
            return _buildTeamsList(context, state.teams);
          } else if (state is ClientHomeTapAllDataFailure) {
            log('ClientHomeTapAllDataFailure : -=-=-----=- ${state.errMessage}');
            return Center(child: Text(state.errMessage));
          } else if (state is ClientHomeTapAllDataSuccess) {
            return _buildTeamsList(context, state.teams);
          } else {
            // Check if we have cached data
            try {
              final cubit = context.read<ClientHomeTapCubit>();
              if (cubit.hasTeamsData && cubit.cachedTeams != null) {
                return _buildTeamsList(context, cubit.cachedTeams!);
              }
            } catch (e) {
              // Cubit might not be available
              log('Error accessing cubit: $e');
            }
            return _buildShimmerLoading(context);
          }
        },
      );
    } catch (e) {
      // Fallback if BlocBuilder fails
      return _buildShimmerLoading(context);
    }
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 24.w),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: theme.colorScheme.secondary.withValues(alpha: 0.3),
            highlightColor: theme.colorScheme.secondary.withValues(alpha: 0.1),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              width: 70.w,
              child: Column(
                children: [
                  Container(
                    width: 65.w,
                    height: 65.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 50.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamsList(BuildContext context, List<TeamsModel> teams) {
    if (teams.isEmpty) {
      return const Center(child: Text("No teams available"));
    }

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 24.w),
        scrollDirection: Axis.horizontal,
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          // Make sure all required fields in team are not null before passing to TopTeamsSection
          return TopTeamsSection(team: team);
        },
      ),
    );
  }
}
