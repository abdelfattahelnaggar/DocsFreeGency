import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_team_requestes_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/repositories/Tasks_Repo/tasks_repository.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class ImplementTasksRepo implements TasksRepository {
  @override
  Future<Either<Failure, TaskModel>> createTask(TaskModel task) {
    // TODO: implement createTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TaskModel>> getTaskById(String id) async {
    log(id);
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.specificTaskEndPoint}/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log(response['data'].toString());
      final taskModel = TaskModel.fromJson(response['data']);
      log(taskModel.toString());
      return right(taskModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<TaskModel>>> getTasks() {
    // TODO: implement getTasks
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TaskModel>> updateTask(String id, TaskModel task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TaskRequestsModel>> getTaskRequests(String id) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.specificTaskEndPoint}/$id/requests',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('A7A A7A A7A =-=--=--: ${response['data']}');
      final taskRequestsModel = TaskRequestsModel.fromJson(response['data']);
      log('A7A A7A A7A =-=--=--: ${taskRequestsModel.toString()}');
      return right(taskRequestsModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
  
  

  
}


/*
@override
  Future<Either<Failure, void>> addTaskToSaved(String taskId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.postData(
        path: '${ApiConstants.specificTaskEndPoint}/$taskId/save',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> removeTaskFromSaved(String taskId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.deleteData(
        path: '${ApiConstants.specificTaskEndPoint}/$taskId/unsave',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
 */