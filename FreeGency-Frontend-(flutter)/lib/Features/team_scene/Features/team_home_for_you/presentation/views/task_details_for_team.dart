import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/repositories/Tasks_Repo/implemented_tasks_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/tasks_cubit/cubit/tasks_functionality_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/widgets/task_details_for_team_body.dart';

class TaskDetailsForTeam extends StatelessWidget {
  const TaskDetailsForTeam({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taskId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider(
      create: (context) =>
          TasksFunctionalityCubit(ImplementTasksRepo())..getTaskById(taskId!),
      child: const TaskDetailsForTeamBody(),  
    );
  }
}