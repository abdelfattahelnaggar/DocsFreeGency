import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/models/join_team_request_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/models/join_team_response_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/repositories/join_team_repo.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class JoinTeamRepoImplementation extends JoinTeamRepo {
  @override
  Future<Either<Failure, String>> sendJoinRequest(
      JoinTeamRequestModel joinTeamRequestModel) async {
    try {
      final token = await LocalStorage.getToken();

      final response = await ApiService.instance.postData(
        path: ApiConstants.joinTeamEndPoint,
        body: joinTeamRequestModel.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return right(response['message'] ?? 'Join request sent successfully');
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
  Future<Either<Failure, String>> acceptJoinRequest(String requestId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.patchData(
        path: '${ApiConstants.handleJoinRequestEndPoint}/$requestId/accept',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return right(response['message'] ?? 'Join request accepted successfully');
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
  Future<Either<Failure, String>> rejectJoinRequest(String requestId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.patchData(
        path: '${ApiConstants.handleJoinRequestEndPoint}/$requestId/reject',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return right(response['message'] ?? 'Join request rejected successfully');
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
  Future<Either<Failure, JoinTeamResponseModel>> getSpecificJoinRequest(String requestId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.handleJoinRequestEndPoint}/$requestId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return right(JoinTeamResponseModel.fromJson(response['data']));
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
