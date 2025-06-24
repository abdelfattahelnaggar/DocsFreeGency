import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/models/post_job_request_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/models/post_job_response_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/repositories/post_job_repo.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class PostJobRepoImplementation implements PostJobRepo {
  @override
  Future<Either<Failure, PostJobResponseModel?>> postJob(
    PostJobRequestModel postJobRequestModel,
  ) async {
    try {
      final token = await LocalStorage.getToken();

      final response = await ApiService.instance.postData(
        path: ApiConstants.postJobEndPoint,
        body: postJobRequestModel.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return right(PostJobResponseModel.fromJson(response));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure(errorMessage: e.response?.data['message']));
      }
      return left(ServerFailure(errorMessage: 'Something went wrong'));
    }
  }
}
