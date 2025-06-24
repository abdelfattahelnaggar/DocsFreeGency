import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/assign_task_to_member_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/sub_task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/team_member_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class TaskManagementForTeamRepository {
  Future<Either<String, List<TaskModel>>> getTasksForTeam();
  Future<Either<String, List<TaskModel>>> getAssignedTasksForMember();
  Future<Either<Failure, String>> updateTaskStatus(String taskId);
  Future<Either<Failure, List<TeamMemberModel>>> getTeamMembers();
  Future<Either<Failure, String>> assignTaskToMember(
      AssignTaskToMemberModel assignTaskToMemberModel, String taskId);
  Future<Either<Failure, List<SubTaskModel>>> getSubTasks(String taskId);
  Future<Either<Failure, String>> addCommentToSubTask(
      String subTaskId, String comment);
}
