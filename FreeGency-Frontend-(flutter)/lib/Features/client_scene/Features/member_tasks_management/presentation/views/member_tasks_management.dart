import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/task_management_for_team_body.dart';

class MemberTasksManagement extends StatelessWidget {
  const MemberTasksManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeamTaskManagementCubit(),
      child: const TaskManagementForTeamBody(),
    );
  }
}
