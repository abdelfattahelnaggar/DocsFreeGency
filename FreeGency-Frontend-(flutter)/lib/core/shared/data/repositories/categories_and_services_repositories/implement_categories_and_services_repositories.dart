import 'package:dartz/dartz.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/shared/data/models/categories_and_its_services_model.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

import 'categories_and_services_repositories.dart';

class CategoriesAndServicesRepositoriesImplementation
    extends CategoriesAndServicesRepositories {
  final ApiService apiService = ApiService.instance;

  @override
  Future<Either<Failure, CategoriesAndItsServicesModel>>
      getCategoriesAndServices() async {
    try {
      final response =
          await apiService.getData(path: ApiConstants.categoriesEndPoint);

      final model = CategoriesAndItsServicesModel.fromJson(response);
      return Right(model);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceModel>>> getServices({
    required String categoryID,
  }) async {
    try {
      final response = await apiService.getData(
          path: '${ApiConstants.categoriesEndPoint}/$categoryID');

      final List<ServiceModel> services = (response['data'] as List)
          .map((json) => ServiceModel.fromJson(json))
          .toList();

      return Right(services);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final response =
          await apiService.getData(path: ApiConstants.categoriesEndPoint);

      final List<CategoryModel> categories = (response['data'] as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      return Right(categories);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
