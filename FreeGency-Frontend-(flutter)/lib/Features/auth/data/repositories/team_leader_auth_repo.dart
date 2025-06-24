import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_login_request_model.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/userr_response_model.dart';
import 'package:freegency_gp/Features/auth/data/models/teams_models/team_register_request_model.dart';
import 'package:freegency_gp/Features/auth/data/models/teams_models/team_register_response_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class TeamLeaderAuthRepo {
  // in left side return The Exception, in right side return data
  Future<Either<Failure, UserResponseModel>> teamLeaderLogin(
      UserLoginRequestModel userLoginRequest);
  Future<Either<Failure, TeamRegisterOrCreateResponseModel>>
      teamLeaderCreateTeam(
          TeamRegisterOrCreateRequestModel teamRegisterOrCreateRequestModel);
}
