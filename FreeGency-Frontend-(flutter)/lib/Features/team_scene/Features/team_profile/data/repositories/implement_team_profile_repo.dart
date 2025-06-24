import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/repositories/team_profile_repo.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class TeamProfileRepoImplementation extends TeamProfileRepo {
  @override
  Future<Either<Failure, TeamsModel>> getMyTeamProfile() async {
    try {
      final token = await LocalStorage.getToken();

      final response = await ApiService.instance.getData(
        path: '${ApiConstants.specificTeamEndPoint}/my-team',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final team = TeamsModel.fromJson(response['data']);
      return right(team);
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
  Future<Either<Failure, String>> updateTeamProfile(
      Map<String, dynamic> data) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.patchData(
        path: '${ApiConstants.specificTeamEndPoint}/my-team',
        body: data,
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
  Future<Either<Failure, List<ProjectModel>>> getTeamProjects() async {
    try {
      final token = await LocalStorage.getToken();

      // Get team projects directly from my-team endpoint
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.projectsEndPoint}/my-team',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> responseData = response['data'] as List<dynamic>;
      List<ProjectModel> projects = responseData
          .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return right(projects);
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
  Future<Either<Failure, String>> updateTeamLogo(String imagePath) async {
    try {
      log('Starting team logo update with path: $imagePath');
      final token = await LocalStorage.getToken();
      final file = File(imagePath);

      if (!file.existsSync()) {
        log('File does not exist at path: $imagePath');
        return left(ServerFailure(errorMessage: 'File not found'));
      }

      log('File exists, size: ${file.lengthSync()} bytes');

      // Try using ApiService with the same path as regular team profile update
      try {
        log('Trying with ApiService patch to teams/my-team');

        // Create form data
        FormData formData = FormData.fromMap({
          'logo': await MultipartFile.fromFile(file.path),
        });

        // Use Dio directly since ApiService might not handle FormData properly
        final dio = Dio();
        final response = await dio.patch(
          'https://free-gency-backend-003bbc67b812.herokuapp.com/api/v1/teams/my-team',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        log('Success with teams/my-team! Response status: ${response.statusCode}');
        log('Response data: ${response.data}');

        return right('Logo updated successfully');
      } catch (e) {
        if (e is DioException) {
          log('Error with teams/my-team: ${e.message}');
          log('Status code: ${e.response?.statusCode}');
          log('Response data: ${e.response?.data}');
        } else {
          log('Error with teams/my-team: $e');
        }

        // If that fails, try the other endpoints
        return await _tryOtherEndpoints(file, token!);
      }
    } catch (e) {
      log('Unexpected error in updateTeamLogo: $e');
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  Future<Either<Failure, String>> _tryOtherEndpoints(
      File file, String token) async {
    final dio = Dio();

    // Create form data
    FormData formData = FormData.fromMap({
      'logo': await MultipartFile.fromFile(file.path),
    });

    log('FormData created successfully');

    // Try using the same pattern as team profile update but with different field name
    const baseUrl = 'https://free-gency-backend-003bbc67b812.herokuapp.com';

    final endpoints = [
      '$baseUrl/api/v1/teams/my-team/logo',
      '$baseUrl/api/v1/teams/my-team/image',
    ];

    final methods = ['PATCH', 'POST'];

    for (final method in methods) {
      for (final endpoint in endpoints) {
        try {
          log('Trying $method request to: $endpoint');

          Response response;
          if (method == 'PATCH') {
            response = await dio.patch(
              endpoint,
              data: formData,
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                },
              ),
            );
          } else {
            response = await dio.post(
              endpoint,
              data: formData,
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                },
              ),
            );
          }

          log('Success! Response status: ${response.statusCode}');
          log('Response data: ${response.data}');

          // If we get here, the request was successful
          return right('Logo updated successfully');
        } catch (e) {
          if (e is DioException) {
            log('Error with $method $endpoint: ${e.message}');
            log('Status code: ${e.response?.statusCode}');
            log('Response data: ${e.response?.data}');
          } else {
            log('Error with $method $endpoint: $e');
          }
          // Try the next endpoint
          continue;
        }
      }
    }

    // If all endpoints failed, return error
    log('All endpoints failed for team logo update');
    return left(ServerFailure(
        errorMessage: 'Failed to update team logo - all endpoints failed'));
  }
}
