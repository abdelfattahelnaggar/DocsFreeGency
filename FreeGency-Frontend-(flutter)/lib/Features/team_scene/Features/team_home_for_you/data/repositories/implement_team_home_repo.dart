import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/data/repositories/team_home_repo.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class TeamHomeRepoImplementation extends TeamHomeRepo {
  @override
  Future<Either<Failure, List<TaskModel>>> getBestMatchesTasks() async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: ApiConstants.getTasksByCategoryEndPoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> responseData = response['data'] as List<dynamic>;
      List<TaskModel> tasks = responseData
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();

      List<TaskModel> bestMatchesTasks =
          tasks.where((element) => element.status == 'open').toList();
      return right(bestMatchesTasks);
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
  Future<Either<Failure, List<TaskModel>>> getMostRecentTasks() {
    // TODO: implement getMostRecentTasks
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TaskModel>>> getSavedTasks() async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: ApiConstants.getSavedTasksEndPoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> responseData = response['data'] as List<dynamic>;
      List<TaskModel> savedTasks = responseData
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return right(savedTasks);
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
  Future<Either<Failure, String>> saveTask(String taskId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.postData(
        path: '${ApiConstants.specificTaskEndPoint}/$taskId/save',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return right(response['message']);
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
  Future<Either<Failure, String>> unsaveTask(String taskId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.deleteData(
        path: '${ApiConstants.specificTaskEndPoint}/$taskId/save',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return right(response['message']);
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
