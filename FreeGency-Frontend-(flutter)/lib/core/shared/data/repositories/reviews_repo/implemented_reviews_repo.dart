import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/shared/data/models/review_request_model.dart';
import 'package:freegency_gp/core/shared/data/repositories/reviews_repo/reviews_repository.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class ImplementedReviewsRepo extends ReviewsRepository {
  @override
  Future<Either<Failure, String>> addReview(
      ReviewRequestModel reviewRequestModel) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.postData(
        path: ApiConstants.reviewsEndPoint,
        body: reviewRequestModel.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('A7A A7A A7A =-=--=--: ${response['data']}');
      return const Right('Review added successfully');
    } catch (e) {
      if (e is DioException) {
        return Left(
            ServerFailure(errorMessage: e.response?.data['message'] ?? ''));
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewResponseModel>>> getReviews(
      String projectId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.reviewsEndPoint}/$projectId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final reviewsResponse = GetReviewsResponseModel.fromJson(response);
      log('Reviews fetched successfully: ${reviewsResponse.results} reviews');
      return Right(reviewsResponse.data);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(
            errorMessage:
                e.response?.data['message'] ?? 'Failed to fetch reviews'));
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
