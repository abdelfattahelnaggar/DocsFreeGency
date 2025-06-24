import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/sub_task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_states.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/comment_converter_util.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/date_formatter_util.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/show_all_comments.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/task_card.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';

class BuildTaskInfo extends StatelessWidget {
  final SubTaskModel subTask;

  const BuildTaskInfo({
    super.key,
    required this.subTask,
  });

  @override
  Widget build(BuildContext context) {
    void showCommentsDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (_) => BlocProvider.value(
          value: context.read<TeamTaskManagementCubit>(),
          child: ShowAllComments(
            subTask: subTask,
          ),
        ),
      );
    }

    return BlocListener<TeamTaskManagementCubit, TeamTaskManagementState>(
      listener: (context, state) {
        // Handle comment addition results
        if (state is AddCommentToSubTaskSuccess) {
          // The parent screen already handles success and refreshes
          // We don't need to do anything here as the UI will be updated
          // when the parent refreshes the sub tasks
        } else if (state is AddCommentToSubTaskError) {
          // The parent screen handles error display
          // We don't need to show another snackbar here
        }
      },
      child: FutureBuilder<String?>(
        future: _getCurrentUserId(),
        builder: (context, snapshot) {
          final currentUserId = snapshot.data;

          return TaskCard(
            toMail: subTask.assignedTo.name,
            toName: subTask.assignedTo.name,
            deadLine: DateFormatterUtil.formatDeadline(
                subTask.subtaskDetails.deadline),
            isprogress: subTask.subtaskDetails.status != 'completed',
            comments: CommentConverterUtil.convertCommentsToMap(
              subTask.comments,
              currentUserId: currentUserId,
            ),
            maxCommentsToShow: 3,
            onCommentsTap: () => showCommentsDialog(context),
            subTaskId: subTask.subtaskDetails.id,
            onAddComment: (comment) {
              context.read<TeamTaskManagementCubit>().addCommentToSubTask(
                    subTaskId: subTask.subtaskDetails.id,
                    comment: comment,
                  );
            },
            taskTitle: subTask.subtaskDetails.title,
            assignedMemberId: subTask.assignedTo.id,
          );
        },
      ),
    );
  }

  /// Helper method to get current user ID
  Future<String?> _getCurrentUserId() async {
    final currentUser = await LocalStorage.getUserData();
    return currentUser?.id;
  }
}
