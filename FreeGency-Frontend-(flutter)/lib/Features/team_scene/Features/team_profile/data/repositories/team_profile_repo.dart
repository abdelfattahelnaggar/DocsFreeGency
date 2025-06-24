import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class TeamProfileRepo {
  Future<Either<Failure, TeamsModel>> getMyTeamProfile();
  Future<Either<Failure, List<ProjectModel>>> getTeamProjects();
  Future<Either<Failure, String>> updateTeamProfile(Map<String, dynamic> data);
  Future<Either<Failure, String>> updateTeamLogo(String imagePath);
}
