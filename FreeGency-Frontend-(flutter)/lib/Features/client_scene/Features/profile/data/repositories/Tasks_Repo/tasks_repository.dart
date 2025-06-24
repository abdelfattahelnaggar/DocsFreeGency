import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_team_requestes_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class TasksRepository {
  Future<Either<Failure, List<TaskModel>>> getTasks();
  Future<Either<Failure, TaskModel>> getTaskById(String id);
  Future<Either<Failure, TaskModel>> createTask(TaskModel task);
  Future<Either<Failure, TaskModel>> updateTask(String id, TaskModel task);
  Future<Either<Failure, void>> deleteTask(String id);
  Future<Either<Failure, TaskRequestsModel>> getTaskRequests(String id);
  
}
