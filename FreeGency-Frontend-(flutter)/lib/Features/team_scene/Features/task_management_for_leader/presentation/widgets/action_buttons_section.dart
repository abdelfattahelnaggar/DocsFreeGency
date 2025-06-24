import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/chat_button_widget.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/status_dropdown_widget.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/time_remaining_widget.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class ActionButtonsSection extends StatelessWidget {
  final TaskModel task;

  const ActionButtonsSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              const ChatButtonWidget(),
              8.width,
              FutureBuilder(
                future: context
                    .read<TeamTaskManagementCubit>()
                    .isCurrentUserTeamLeader(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return StatusDropdownWidget(task: task);
                  }
                  return SizedBox(
                    height: 55.h,
                  );
                },
              ),
            ],
          ),
        ),
        TimeRemainingWidget(task: task),
      ],
    );
  }
}
