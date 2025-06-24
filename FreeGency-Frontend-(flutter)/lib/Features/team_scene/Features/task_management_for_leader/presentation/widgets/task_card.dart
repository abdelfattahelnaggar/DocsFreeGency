import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/comment_widget.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/reply_build.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class TaskCard extends StatelessWidget {
  final String toMail;
  final String toName;
  final String deadLine;
  final bool isprogress;
  final List<Map<String, dynamic>> comments;
  final int? maxCommentsToShow;
  final String teamLeaderName;
  final VoidCallback? onCommentsTap;
  final String? subTaskId;
  final Function(String)? onAddComment;
  final String? taskTitle;
  final String? assignedMemberId;

  const TaskCard({
    super.key,
    required this.toMail,
    required this.toName,
    required this.deadLine,
    required this.isprogress,
    required this.comments,
    this.maxCommentsToShow,
    this.teamLeaderName = "Team Leader",
    this.onCommentsTap,
    this.subTaskId,
    this.onAddComment,
    this.taskTitle,
    this.assignedMemberId,
  });

  @override
  Widget build(BuildContext context) {
    // Show the last N comments instead of the first N comments
    // This ensures users see the most recent conversation
    final commentsToShow =
        (maxCommentsToShow != null && comments.length > maxCommentsToShow!)
            ? comments.skip(comments.length - maxCommentsToShow!).toList()
            : comments;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'to $toMail ($toName)',
            style: AppTextStyles.poppins12Regular(context)!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 90,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isprogress
                      ? const Color(0xFFFF0000).withValues(alpha: 0.1)
                      : const Color(0xFF2DD000).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    isprogress ? "in progress" : "Completed",
                    style: AppTextStyles.poppins12Regular(context)!.copyWith(
                      color: isprogress
                          ? const Color(0xFFFF0000)
                          : const Color(0xFF2DD000),
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              if (isprogress)
                Flexible(
                  child: Text(
                    "Deadline $deadLine",
                    style: AppTextStyles.poppins12Regular(context)!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          10.height,
          Text(
            taskTitle ?? "Make The Theme File",
            style: AppTextStyles.poppins16Bold(context)!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
          5.height,
          if (commentsToShow.isNotEmpty)
            InkWell(
              onTap: onCommentsTap,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (maxCommentsToShow != null &&
                      comments.length > maxCommentsToShow!)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.comment_outlined,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comments.length - maxCommentsToShow!} more comments... Tap to view all',
                            style: AppTextStyles.poppins12Regular(context)!
                                .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ...commentsToShow.map((comment) {
                    return CommentWidget(
                      comment: comment,
                      teamName: teamLeaderName,
                      assignedMemberId: assignedMemberId,
                    );
                  }).toList(),
                ],
              ),
            ),
          ReplyBuild(
            subTaskId: subTaskId,
            onAddComment: onAddComment,
          ),
        ],
      ),
    );
  }
}
