import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_login_request_model.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/userr_response_model.dart';
import 'package:freegency_gp/Features/auth/data/models/teams_models/team_register_request_model.dart';
import 'package:freegency_gp/Features/auth/data/models/teams_models/team_register_response_model.dart';
import 'package:freegency_gp/Features/auth/data/repositories/team_leader_auth_repo.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';

class TeamLeaderAuthRepoImplementation extends TeamLeaderAuthRepo {
  @override
  Future<Either<Failure, TeamRegisterOrCreateResponseModel>>
      teamLeaderCreateTeam(
          TeamRegisterOrCreateRequestModel
              teamRegisterOrCreateRequestModel) async {
    try {
      var response = await ApiService.instance.postData(
        path: ApiConstants.teamCreateOrSignUpEndPoint,
        body: teamRegisterOrCreateRequestModel.toJson(),
      );

      final registerModel =
          TeamRegisterOrCreateResponseModel.fromJson(response);
      return right(registerModel);
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
  Future<Either<Failure, UserResponseModel>> teamLeaderLogin(
      UserLoginRequestModel userLoginRequest) async {
    try {
      var response = await ApiService.instance.postData(
        path: ApiConstants.teamLoginEndPoint,
        body: userLoginRequest.toJson(),
      );

      final loginModel = UserResponseModel.fromJson(response);
      return right(loginModel);
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
