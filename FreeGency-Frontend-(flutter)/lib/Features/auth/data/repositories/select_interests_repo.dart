import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/shared/data/models/categories_and_its_services_model.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

abstract class SelectInterestsRepo {
  Future<Either<Failure, List<CategoryModel>>> sendInterests(
      List<String> interests);
}

class SelectInterestsRepoImplementation extends SelectInterestsRepo {
  @override
  Future<Either<Failure, List<CategoryModel>>> sendInterests(
      List<String> interests) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.patchData(
        path: ApiConstants.userProfileEndPoint,
        body: {
          'interests': interests,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // The backend returns the updated user with interests
      // We don't need to parse anything, just return success
      return right([]);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
