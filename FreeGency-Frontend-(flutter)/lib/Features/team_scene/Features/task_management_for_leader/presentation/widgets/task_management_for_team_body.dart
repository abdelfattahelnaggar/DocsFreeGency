import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_states.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/body_in_error_state_in_get_tasks.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/body_in_success_state_to_get_tasks.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';

class TaskManagementForTeamBody extends StatefulWidget {
  const TaskManagementForTeamBody({
    super.key,
  });

  @override
  State<TaskManagementForTeamBody> createState() =>
      _TaskManagementForTeamBodyState();
}

class _TaskManagementForTeamBodyState extends State<TaskManagementForTeamBody> {
  @override
  void initState() {
    super.initState();
    // Fetch team tasks when the widget initializes
    context.read<TeamTaskManagementCubit>().getTeamTasks();
  }

  /// Handle refresh functionality
  Future<void> _onRefresh() async {
    await context.read<TeamTaskManagementCubit>().getTeamTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TeamTaskManagementCubit, TeamTaskManagementState>(
        builder: (context, state) {
          if (state is TeamTaskManagementLoading) {
            return const Center(child: AppLoadingIndicator());
          }

          if (state is TeamTaskManagementError) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: BodyInErrorState(errorMessage: state.errorMessage),
            );
          }

          if (state is TeamTaskManagementSuccess) {
            final allTasks = state.tasks;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: BodyInSuccessState(allTasks: allTasks),
            );
          }

          // Initial state - show loading
          return const Center(child: AppLoadingIndicator());
        },
      ),
    );
  }
}
