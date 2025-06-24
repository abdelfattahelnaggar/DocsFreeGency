import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/data/available_jobs_repository/available_jobs_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/data/models/job_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class ImplementedAvailableJobsRepo implements AvailableJobsRepository {
  @override
  Future<Either<Failure, List<JobModel>>> getAvailableJobs(
      String? categoryId) async {
    try {
      final token = await LocalStorage.getToken();
      final response;
      if (categoryId != null) {
        response = await ApiService.instance.getData(
          path: 'jobs?categoryId=$categoryId',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
        log('resآعمممممممممممممponse ////*/*/**/*//*/*/*/*: ${response['data']}');
      } else {
        response = await ApiService.instance.getData(
          path: 'jobs',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
        log('respoسيسيسيسيnse ////*/*/**/*//*/*/*/*: ${response['data']}');
      }
      log('response ////*/*/**/*//*/*/*/*: ${response['data']}');

      final List<dynamic> jobsData = response['data'] as List<dynamic>;
      final List<JobModel> jobs = jobsData
          .map((jobJson) => JobModel.fromJson(jobJson as Map<String, dynamic>))
          .toList();

      return Right(jobs);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(
            errorMessage:
                e.response?.data['message'] ?? 'something went wrong'));
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
