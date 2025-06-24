import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class TeamHomeRepo {
  Future<Either<Failure, List<TaskModel>>> getBestMatchesTasks();
  Future<Either<Failure, List<TaskModel>>> getMostRecentTasks();
  Future<Either<Failure, List<TaskModel>>> getSavedTasks();
  Future<Either<Failure, String>> saveTask(String taskId);
  Future<Either<Failure, String>> unsaveTask(String taskId);
}
