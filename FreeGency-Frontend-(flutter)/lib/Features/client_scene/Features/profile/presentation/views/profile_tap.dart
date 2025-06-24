import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/views/client_auth_screen/views/client_register_auth_screen.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/views/team_leader_create_account.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/user_data_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/head_profile_info.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/join_team_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/statistics_with_data_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/tasks_list.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class ProfileTap extends StatelessWidget {
  final bool? isGuest;
  const ProfileTap(
      {super.key, required this.scrollController, this.isGuest = false});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserDataFunctionalityCubit>();
    if (isGuest == false) {
      if (cubit.state is UserDataFunctionalityInitial ||
          cubit.state is GetAllUserDataError ||
          cubit.state is GetUserDataError ||
          cubit.state is GetMyTasksError) {
        cubit.getUserWithTasks();
      }
    }

    return isGuest == true
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReusableTextStyleMethods.poppins16BoldMethod(
                context: context,
                text: 'No Account is logged in',
              ),
              8.height,
              PrimaryCTAButton(
                label: 'Continue as a client',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClientRegisterAuthScreen(),
                    ),
                  );
                },
              ),
              8.height,
              PrimaryCTAButton(
                label: 'Continue as a team',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeamLeaderCreateAccount(),
                    ),
                  );
                },
              ),
            ],
          )
        : ProfileTapBody(scrollController: scrollController);
  }
}

class ProfileTapBody extends StatelessWidget {
  const ProfileTapBody({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final userDataCubit = context.read<UserDataFunctionalityCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: RefreshIndicator(
        onRefresh: () async {
          // Force refresh data when user pulls down
          await userDataCubit.refreshAllData();
        },
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.height,
              const HeadProfileInfoSection(),
              8.height,
              PrimaryCTAButton(
                label: context.tr('my_applications'),
                onTap: () {},
              ),
              16.height,
              const JoinTeamSection(),
              24.height,
              ReusableTextStyleMethods.poppins16BoldMethod(
                context: context,
                text: context.tr('my_statistics'),
              ),
              16.height,
              const StatisticsWithDataSection(),
              24.height,
              ReusableTextStyleMethods.poppins16BoldMethod(
                context: context,
                text: context.tr('my_projects'),
              ),
              16.height,
              // My Projects
              const TasksList(),
              24.height,
            ],
          ),
        ),
      ),
    );
  }
}
