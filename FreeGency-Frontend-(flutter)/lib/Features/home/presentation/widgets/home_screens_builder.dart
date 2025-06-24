import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/presentation/views/jobs_tap.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/views/home_tap.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/views/inbox_tap.dart';
import 'package:freegency_gp/Features/client_scene/Features/member_tasks_management/presentation/views/member_tasks_management.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/views/profile_tap.dart';
import 'package:freegency_gp/Features/home/presentation/view_model/cubits/client_home_page/client_home_page_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/presentation/views/my_jobs_screen.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/views/task_management_for_team.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/views/team_home_for_you_screen.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/views/team_profile.dart';

class HomeScreensBuilder extends StatelessWidget {
  final ClientHomePageCubit cubit;
  final int index;

  const HomeScreensBuilder({
    super.key,
    required this.cubit,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Check if screen has been visited
    if (!cubit.isScreenVisited(index)) {
      return _buildPlaceholderScreen();
    }

    // Build the actual screen based on user role and index
    return _buildScreen(index);
  }

  Widget _buildScreen(int index) {
    if (cubit.isClient) {
      return _buildClientScreen(index);
    } else if (cubit.isTeamLeader) {
      return _buildTeamLeaderScreen(index);
    } else if (cubit.isTeamMember) {
      return _buildTeamMemberScreen(index);
    } else {
      return _buildGuestScreen(index);
    }
  }

  Widget _buildClientScreen(int index) {
    switch (index) {
      case 0:
        return ClientHomeTap(
          key: const ValueKey('client_home'),
          scrollController: cubit.getScrollController('client_home'),
        );
      case 1:
        return const InboxTap(key: ValueKey('client_inbox'));
      case 2:
        return ProfileTap(
          key: const ValueKey('client_profile'),
          scrollController: cubit.getScrollController('client_profile'),
        );
      case 3:
        return JobsTap(
          key: const ValueKey('client_jobs'),
          scrollController: cubit.getScrollController('client_jobs'),
        );
      default:
        return _buildPlaceholderScreen();
    }
  }

  Widget _buildTeamLeaderScreen(int index) {
    switch (index) {
      case 0:
        return const TeamHomeForYouScreen(key: ValueKey('leader_home'));
      case 1:
        return const InboxTap(key: ValueKey('leader_inbox'));
      case 2:
        return const MyTeamProfileScreen(key: ValueKey('leader_team_profile'));
      case 3:
        return const TaskManagementForTeam(key: ValueKey('leader_tasks'));
      case 4:
        return const MyJobsScreen(key: ValueKey('leader_my_jobs'));
      default:
        return _buildPlaceholderScreen();
    }
  }

  Widget _buildTeamMemberScreen(int index) {
    switch (index) {
      case 0:
        return ClientHomeTap(
          key: const ValueKey('client_home'),
          scrollController: cubit.getScrollController('client_home'),
        );
      case 1:
        return const InboxTap(key: ValueKey('member_inbox'));
      case 2:
        return ProfileTap(
          key: const ValueKey('member_profile1'),
          scrollController: cubit.getScrollController('member_profile1'),
        );
      case 3:
        return const MemberTasksManagement(
          key: ValueKey('member_tasks_management'),
        );
      case 4:
        return JobsTap(
          key: const ValueKey('member_jobs'),
          scrollController: cubit.getScrollController('member_jobs'),
        );
      default:
        return _buildPlaceholderScreen();
    }
  }

  Widget _buildGuestScreen(int index) {
    switch (index) {
      case 0:
        return ClientHomeTap(
          key: const ValueKey('guest_home'),
          scrollController: cubit.getScrollController('guest_home'),
        );
      case 1:
        return ProfileTap(
          key: const ValueKey('guest_profile'),
          scrollController: cubit.getScrollController('guest_profile'),
          isGuest: true,
        );
      case 2:
        return JobsTap(
          key: const ValueKey('guest_jobs'),
          scrollController: cubit.getScrollController('guest_jobs'),
        );
      default:
        return _buildPlaceholderScreen();
    }
  }

  Widget _buildPlaceholderScreen() {
    return const SizedBox.shrink();
  }
}
