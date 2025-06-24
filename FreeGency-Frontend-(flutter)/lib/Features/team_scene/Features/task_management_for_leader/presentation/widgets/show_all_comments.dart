import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/sub_task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_states.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/comment_widget.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';

/// Dialog widget for displaying all comments of a sub task (read-only)
///
/// This is a view-only dialog that shows all comments for a specific sub task.
/// To add new comments, users should close this dialog and use the reply functionality
/// in the main task card interface.
class ShowAllComments extends StatelessWidget {
  final SubTaskModel subTask;

  const ShowAllComments({
    super.key,
    required this.subTask,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamTaskManagementCubit, TeamTaskManagementState>(
      builder: (context, state) {
        // Get the most up-to-date sub task data
        SubTaskModel currentSubTask = subTask;

        // Check if we have updated data in the state
        if (state is SubTasksUpdatedWithComment) {
          // Find the current sub task in the updated list
          final updated = state.subTasks.firstWhere(
            (st) => st.subtaskDetails.id == subTask.subtaskDetails.id,
            orElse: () => subTask,
          );
          currentSubTask = updated;
        } else if (state is AddCommentToSubTaskSuccess) {
          // Use the updated sub tasks from success state
          final updated = state.updatedSubTasks.firstWhere(
            (st) => st.subtaskDetails.id == subTask.subtaskDetails.id,
            orElse: () => subTask,
          );
          currentSubTask = updated;
        } else if (state is AddCommentToSubTaskError) {
          // Use the reverted sub tasks from error state
          final updated = state.revertedSubTasks.firstWhere(
            (st) => st.subtaskDetails.id == subTask.subtaskDetails.id,
            orElse: () => subTask,
          );
          currentSubTask = updated;
        }

        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        currentSubTask.subtaskDetails.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Comments (${currentSubTask.comments.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                // Comments list
                Expanded(
                  child: currentSubTask.comments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No comments yet',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Go back to add the first comment!',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: currentSubTask.comments.length,
                          itemBuilder: (context, index) {
                            final comment = currentSubTask.comments[index];

                            return FutureBuilder<String?>(
                              future: _getCurrentUserId(),
                              builder: (context, snapshot) {
                                final currentUserId = snapshot.data;

                                // Determine role based on whether this is the current user
                                int role = 1; // Default to team member
                                if (currentUserId != null &&
                                    comment.user.id == currentUserId) {
                                  role = 0; // Current user/Team leader
                                }

                                final commentMap = {
                                  "role": role,
                                  "name": comment.user.name,
                                  "imageUrl": comment.user.profileImage,
                                  "comment": comment.text,
                                  "status":
                                      "now", // You can implement proper time formatting
                                  "userId": comment.user.id,
                                };

                                return CommentWidget(
                                  comment: commentMap,
                                  teamName:
                                      "Team Leader", // Replace with actual team leader name
                                  assignedMemberId:
                                      currentSubTask.assignedTo.id,
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _getCurrentUserId() async {
    final currentUser = await LocalStorage.getUserData();
    return currentUser?.id;
  }
}
