import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/models/job_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/repositories/my_jobs_repository.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class ImplementedMyJobsRepository implements MyJobsRepository {
  @override
  Future<Either<Failure, List<JobModel>>> getMyJobs() async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.postJobEndPoint}/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Handle the response structure - if it's an array directly or wrapped in data
      final List<dynamic> jobsData = response is List
          ? response as List<dynamic>
          : (response['data'] as List<dynamic>? ??
              response['jobs'] as List<dynamic>? ??
              []);

      final List<JobModel> jobs = jobsData
          .map((jobData) => JobModel.fromJson(jobData as Map<String, dynamic>))
          .toList();

      return right(jobs);
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
  Future<Either<Failure, JobModel>> getJobById(String jobId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.postJobEndPoint}/$jobId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Handle the response structure - get the job data
      final jobData = response['data'] ?? response;
      final JobModel job = JobModel.fromJson(jobData);
      return right(job);
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
  Future<Either<Failure, bool>> deleteJob(String jobId) async {
    try {
      final token = await LocalStorage.getToken();
      await ApiService.instance.deleteData(
        path: '${ApiConstants.postJobEndPoint}/$jobId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return right(true);
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
