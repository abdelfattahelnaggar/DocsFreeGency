import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/sub_task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/team_member_model.dart';
import 'package:meta/meta.dart';

@immutable
sealed class TeamTaskManagementState {}

// Initial state
final class TeamTaskManagementInitial extends TeamTaskManagementState {}

// Get team tasks states
final class TeamTaskManagementLoading extends TeamTaskManagementState {}

final class TeamTaskManagementSuccess extends TeamTaskManagementState {
  final List<TaskModel> tasks;

  TeamTaskManagementSuccess({required this.tasks});
}

final class TeamTaskManagementError extends TeamTaskManagementState {
  final String errorMessage;

  TeamTaskManagementError({required this.errorMessage});
}

// Get team members states
final class GetTeamMembersLoading extends TeamTaskManagementState {}

final class GetTeamMembersSuccess extends TeamTaskManagementState {
  final List<TeamMemberModel> teamMembers;

  GetTeamMembersSuccess({required this.teamMembers});
}

final class GetTeamMembersError extends TeamTaskManagementState {
  final String errorMessage;

  GetTeamMembersError({required this.errorMessage});
}

// Assign task to member states
final class AssignTaskToMemberLoading extends TeamTaskManagementState {}

final class AssignTaskToMemberSuccess extends TeamTaskManagementState {
  final String message;

  AssignTaskToMemberSuccess({required this.message});
}

final class AssignTaskToMemberError extends TeamTaskManagementState {
  final String errorMessage;

  AssignTaskToMemberError({required this.errorMessage});
}

// Get sub tasks states
final class GetSubTasksLoading extends TeamTaskManagementState {}

final class GetSubTasksSuccess extends TeamTaskManagementState {
  final List<SubTaskModel> subTasks;

  GetSubTasksSuccess({required this.subTasks});
}

final class GetSubTasksError extends TeamTaskManagementState {
  final String errorMessage;

  GetSubTasksError({required this.errorMessage});
}

// Enhanced comment states with local management
final class AddCommentToSubTaskLoading extends TeamTaskManagementState {
  final String subTaskId; // To identify which sub task is being updated

  AddCommentToSubTaskLoading({required this.subTaskId});
}

final class AddCommentToSubTaskSuccess extends TeamTaskManagementState {
  final String message;
  final List<SubTaskModel> updatedSubTasks; // Updated sub tasks with new comment

  AddCommentToSubTaskSuccess({
    required this.message,
    required this.updatedSubTasks,
  });
}

final class AddCommentToSubTaskError extends TeamTaskManagementState {
  final String errorMessage;
  final List<SubTaskModel> revertedSubTasks; // Reverted sub tasks after error

  AddCommentToSubTaskError({
    required this.errorMessage,
    required this.revertedSubTasks,
  });
}

// New state for optimistic comment updates
final class SubTasksUpdatedWithComment extends TeamTaskManagementState {
  final List<SubTaskModel> subTasks;
  final String pendingCommentId; // To track the optimistic comment

  SubTasksUpdatedWithComment({
    required this.subTasks,
    required this.pendingCommentId,
  });
}
