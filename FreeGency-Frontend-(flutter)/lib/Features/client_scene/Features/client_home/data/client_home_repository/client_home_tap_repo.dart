import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:dartz/dartz.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class ClientHomeTapRepo {
  Future<Either<Failure, List<TeamsModel>>> getTopRatedTeams();
  Future<Either<Failure, List<ProjectModel>>> getInerstedProjects();
  Future<Either<Failure, List<ProjectModel>>> getProjectByCategoryOrService(String path);
  Future<Either<Failure, TeamsModel>> getSpecificTeam(String teamId);
  Future<Either<Failure, ProjectModel>> getSpecificProject(String projectId);
  

}
