import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/view_model/team_task_management_states.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/custom_tast_text.dart';
import 'package:freegency_gp/core/utils/helpers/custom_snackbar.dart';

class ReplyBuild extends StatefulWidget {
  final String? subTaskId;
  final Function(String)? onAddComment;
  // final bool isFirstComment;

  const ReplyBuild({
    super.key,
    this.subTaskId,
    this.onAddComment,
    // this.isFirstComment = false,
  });

  @override
  State<ReplyBuild> createState() => _ReplyBuildState();
}

class _ReplyBuildState extends State<ReplyBuild> {
  final TextEditingController commentController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _handleSendComment() async {
    final commentText = commentController.text.trim();

    // Enhanced validation
    if (commentText.isEmpty) {
      CustomSnackbar.showError(
        title: 'Error',
        message: 'Please write a comment before sending',
      );
      return;
    }

    if (widget.onAddComment == null) {
      CustomSnackbar.showError(
        title: 'Error',
        message: 'Comment functionality is not available',
      );
      return;
    }

    if (widget.subTaskId == null || widget.subTaskId!.isEmpty) {
      CustomSnackbar.showError(
        title: 'Error',
        message: 'Sub task ID is missing',
      );
      return;
    }

    // Show loading state
    setState(() {
      isLoading = true;
    });

    try {
      log('📝 Sending comment: "$commentText" for subTaskId: ${widget.subTaskId}');

      // Call the callback
      widget.onAddComment!(commentText);

      log('📤 Comment callback executed');
    } catch (e) {
      log('❌ Error sending comment: $e');
      CustomSnackbar.showError(
        title: 'Error',
        message: 'Failed to send comment: ${e.toString()}',
      );

      // Reset loading state on error
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine button text based on whether this is the first comment
    final buttonText = "Reply";
    final hintText = "Write your reply..";

    return BlocListener<TeamTaskManagementCubit, TeamTaskManagementState>(
      listener: (context, state) {
        if (state is AddCommentToSubTaskSuccess) {
          // Clear text field only on success
          commentController.clear();
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        } else if (state is AddCommentToSubTaskError) {
          // Reset loading state on error
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        } else if (state is AddCommentToSubTaskLoading) {
          // Set loading state only for this sub task
          if (state.subTaskId == widget.subTaskId && mounted) {
            setState(() {
              isLoading = true;
            });
          }
        } else if (state is SubTasksUpdatedWithComment) {
          // Comment added optimistically, clear field and loading
          commentController.clear();
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        }
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: commentController,
              maxLines: 3,
              enabled: !isLoading,
              style: TextStyle(
                color: isLoading ? Colors.grey.withOpacity(0.5) : Colors.grey,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: isLoading ? null : _handleSendComment,
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: isLoading
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.6)
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : CustomContainerText(
                        text: buttonText,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
