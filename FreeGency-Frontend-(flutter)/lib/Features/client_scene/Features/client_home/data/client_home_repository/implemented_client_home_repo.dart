import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/client_home_repository/client_home_tap_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class ImplementedClientHomeRepo implements ClientHomeTapRepo {
  @override
  Future<Either<Failure, List<TeamsModel>>> getTopRatedTeams() async {
    try {
      final response = await ApiService.instance.getData(
        path: ApiConstants.topRatedTeamsEndPoint,
      );
      final List<dynamic> teamsData = response['data'] as List<dynamic>;
      final List<TeamsModel> teams = teamsData
          .map((teamData) =>
              TeamsModel.fromJson(teamData as Map<String, dynamic>))
          .toList();
      return right(teams);
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
  Future<Either<Failure, List<ProjectModel>>> getInerstedProjects() async {
    try {
      final token = await LocalStorage.getToken();

      final response = await ApiService.instance.getData(
        path: ApiConstants.interestedProjectsEndPoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('=-=-=----=--=-=Response--=-=-=-=--=- $response');
      final List<dynamic> projectsData = response['data'] as List<dynamic>;
      log('=-=-=----=--=-=-ProjectsDAta-=-=-=-=--=- $projectsData');
      final List<ProjectModel> projects = projectsData
          .map((projectData) =>
              ProjectModel.fromJson(projectData as Map<String, dynamic>))
          .toList();
      log('=-=-=----=--=-=-Pro-=-=-=-=--=- $projects');
      return right(projects);
    } catch (e) {
      log('=-=-=----=--=-=-yruturhytrhbf-=-=-=-=--=- ${e.toString()}');
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
  Future<Either<Failure, List<ProjectModel>>> getProjectByCategoryOrService(
      String path) async {
    try {
      final response =
          await ApiService.instance.getData(path: '$path/projects');
      log('Response data structure: ${response.toString()}');
      final List<dynamic> projectsData = response['data'] as List<dynamic>;

      if (projectsData.isNotEmpty) {
        final firstItem = projectsData[0];
        log('Project data first item: ${firstItem.toString()}');
        log('Image cover type: ${firstItem['imageCover'].runtimeType}');
        log('Category type: ${firstItem['category'].runtimeType}');
        log('Service type: ${firstItem['service'].runtimeType}');

        // Additional debugging for team field
        if (firstItem['team'] != null) {
          log('Team type: ${firstItem['team'].runtimeType}');
          if (firstItem['team'] is Map) {
            final teamMap = firstItem['team'] as Map<String, dynamic>;
            log('Team contains category: ${teamMap.containsKey('category')}');
            if (teamMap.containsKey('category')) {
              log('Team category type: ${teamMap['category'].runtimeType}');
            }
          }
        }
      }

      List<ProjectModel> projects = [];
      for (var i = 0; i < projectsData.length; i++) {
        try {
          final projectData = projectsData[i] as Map<String, dynamic>;

          // Create a copy of the data that we can modify safely
          final Map<String, dynamic> safeCopy =
              Map<String, dynamic>.from(projectData);

          // Try to parse the team separately first
          if (safeCopy['team'] != null && safeCopy['team'] is Map) {
            try {
              // final teamMap = safeCopy['team'] as Map<String, dynamic>;
              log('Processing team at index $i');
              // TeamsModel team = TeamsModel.fromJson(teamMap);
              // If team parsing worked, continue with the project
              final project = ProjectModel.fromJson(safeCopy);
              projects.add(project);
            } catch (teamError) {
              log('Error parsing team at index $i: ${teamError.toString()}');
              // If team parsing fails, set to null and try to parse the project
              safeCopy['team'] = null;
              final project = ProjectModel.fromJson(safeCopy);
              projects.add(project);
            }
          } else {
            // No team or team is not a map
            final project = ProjectModel.fromJson(safeCopy);
            projects.add(project);
          }
        } catch (e) {
          log('Error parsing project at index $i: ${e.toString()}');
          // Continue with the next project
        }
      }

      return right(projects);
    } catch (e) {
      log('Error in getProjectByCategoryOrService: ${e.toString()}');
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
  Future<Either<Failure, ProjectModel>> getSpecificProject(String projectId) async{
    try {
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.projectsEndPoint}/$projectId',
      );
      return right(ProjectModel.fromJson(response['data']));
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
  Future<Either<Failure, TeamsModel>> getSpecificTeam(String teamId) async {
    try {
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.specificTeamEndPoint}/$teamId',
      );
      log('=-=-=----=--=-=-Team Response--=-=-=-=--=- $response');
      final TeamsModel team = TeamsModel.fromJson(response['data']);
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
}
