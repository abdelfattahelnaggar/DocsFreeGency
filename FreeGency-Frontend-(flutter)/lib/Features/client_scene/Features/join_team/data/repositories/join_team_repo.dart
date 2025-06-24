import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/models/join_team_request_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/models/join_team_response_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class JoinTeamRepo {
  Future<Either<Failure, String>> sendJoinRequest(JoinTeamRequestModel joinTeamRequestModel);
  Future<Either<Failure, String>> acceptJoinRequest(String requestId);
  Future<Either<Failure, String>> rejectJoinRequest(String requestId);
  Future<Either<Failure, JoinTeamResponseModel>> getSpecificJoinRequest(String requestId);
}
