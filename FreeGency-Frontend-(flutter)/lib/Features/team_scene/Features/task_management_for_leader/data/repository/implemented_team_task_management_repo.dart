import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/assign_task_to_member_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/sub_task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/team_member_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/repository/task_management_for_team_repository.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class ImplementedTeamTaskManagementRepo
    extends TaskManagementForTeamRepository {
  @override
  Future<Either<String, List<TaskModel>>> getTasksForTeam() async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
          path: '${ApiConstants.specificTaskEndPoint}/my-tasks',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final List<TaskModel> tasks = (response['data'] as List)
          .map((task) => TaskModel.fromJson(task))
          .toList();
      return right(tasks);
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TaskModel>>> getAssignedTasksForMember() async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
          path: '${ApiConstants.specificTaskEndPoint}/my-assigned-tasks',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final List<TaskModel> tasks = (response['data'] as List)
          .map((task) => TaskModel.fromJson(task))
          .toList();
      return right(tasks);
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }

  @override
  Future<Either<Failure, String>> updateTaskStatus(String taskId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.patchData(
          path: '${ApiConstants.specificTaskEndPoint}/$taskId/mark-completed',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
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
  Future<Either<Failure, List<TeamMemberModel>>> getTeamMembers() async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
          path: '${ApiConstants.specificTeamEndPoint}/my-team/members',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final List<TeamMemberModel> teamMembers = (response['data'] as List)
          .map((member) => TeamMemberModel.fromJson(member))
          .toList();

      // Safe logging - check if list is not empty before accessing first element
      if (teamMembers.isNotEmpty) {
        log('✅ Team members loaded successfully: ${teamMembers.length} members');
        log('👤 First Member: ${teamMembers[0].user?.name ?? "Unknown"}');
      } else {
        log('👥 No team members found');
      }

      return right(teamMembers);
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
  Future<Either<Failure, String>> assignTaskToMember(
      AssignTaskToMemberModel assignTaskToMemberModel, String taskId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.postData(
          path: '${ApiConstants.postTaskEndPoint}/$taskId/subtasks',
          body: assignTaskToMemberModel.toJson(),
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return right(response['message'] ?? 'Task assigned successfully');
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
  Future<Either<Failure, List<SubTaskModel>>> getSubTasks(String taskId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
          path: '${ApiConstants.specificTaskEndPoint}/$taskId/subtasks',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final List<SubTaskModel> subTasks = (response['data'] as List)
          .map((subTask) => SubTaskModel.fromJson(subTask))
          .toList();

      // Safe logging - check if list is not empty before accessing first element
      if (subTasks.isNotEmpty) {
        log('✅ SubTasks loaded successfully: ${subTasks.length} items');
        log('📋 First SubTask: ${subTasks[0].subtaskDetails.title}');
      } else {
        log('📝 No sub tasks found for task: $taskId');
      }

      return right(subTasks);
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
  Future<Either<Failure, String>> addCommentToSubTask(
      String subTaskId, String comment) async {
    try {
      // Enhanced validation
      if (subTaskId.isEmpty) {
        log('❌ addCommentToSubTask: subTaskId is empty');
        return left(ServerFailure(errorMessage: 'Sub task ID cannot be empty'));
      }

      if (comment.trim().isEmpty) {
        log('❌ addCommentToSubTask: comment is empty');
        return left(
            ServerFailure(errorMessage: 'Comment text cannot be empty'));
      }

      final token = await LocalStorage.getToken();
      if (token == null || token.isEmpty) {
        log('❌ addCommentToSubTask: token is null or empty');
        return left(
            ServerFailure(errorMessage: 'Authentication token is missing'));
      }

      // Try different field names that the API might expect
      // Start with 'text' as it's more common in comment APIs
      final requestBody = {'text': comment.trim()};
      final endpoint = '${ApiConstants.subTasksEndPoint}/$subTaskId/comments';

      log('📝 addCommentToSubTask - Sending request:');
      log('   📍 Full Endpoint: $endpoint');
      log('   🔗 Base URL: ${ApiConstants.subTasksEndPoint}');
      log('   🔑 SubTaskId: $subTaskId');
      log('   💬 Comment: "${comment.trim()}"');
      log('   📦 Request body: $requestBody');
      log('   🎯 Content-Type: application/json');
      log('   🔐 Has Token: ${token.isNotEmpty}');

      final response = await ApiService.instance.postData(
          path: endpoint,
          body: requestBody,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }));

      log('✅ addCommentToSubTask - Response received:');
      log('   📊 Full Response: $response');
      log('   📈 Response Type: ${response.runtimeType}');

      final message = response['message'] ??
          response['data']?['message'] ??
          response['success']?.toString() ??
          'Comment added successfully';
      log('✅ addCommentToSubTask - Success: $message');

      return right(message);
    } catch (e) {
      log('❌ addCommentToSubTask - Error occurred: $e');
      log('   🔍 Error Type: ${e.runtimeType}');

      if (e is DioException) {
        final statusCode = e.response?.statusCode ?? 0;
        final responseData = e.response?.data;
        final requestData = e.requestOptions.data;
        final requestPath = e.requestOptions.path;

        log('❌ addCommentToSubTask - DioException details:');
        log('   🔢 Status Code: $statusCode');
        log('   📨 Response Data: $responseData');
        log('   📤 Request Data: $requestData');
        log('   🛣️ Request Path: $requestPath');
        log('   🌐 Request Headers: ${e.requestOptions.headers}');

        // Extract error message from different possible locations
        String errorMessage = 'Failed to add comment';

        if (responseData != null) {
          if (responseData is Map) {
            errorMessage = responseData['message'] ??
                responseData['error'] ??
                responseData['errors']?.toString() ??
                responseData.toString();
          } else {
            errorMessage = responseData.toString();
          }
        } else if (e.message != null) {
          errorMessage = e.message!;
        }

        log('   💬 Final Error Message: $errorMessage');

        return left(ServerFailure(errorMessage: errorMessage));
      } else if (e is Failure) {
        log('❌ addCommentToSubTask - Failure: ${e.errorMessage}');
        return left(e);
      } else {
        final errorMessage = 'Unexpected error: ${e.toString()}';
        log('❌ addCommentToSubTask - Unexpected error: $errorMessage');
        return left(ServerFailure(errorMessage: errorMessage));
      }
    }
  }
}
