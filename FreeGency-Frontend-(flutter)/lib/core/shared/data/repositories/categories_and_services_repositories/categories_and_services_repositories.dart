import 'package:dartz/dartz.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/shared/data/models/categories_and_its_services_model.dart';

abstract class CategoriesAndServicesRepositories {
  Future<Either<Failure, CategoriesAndItsServicesModel>>
      getCategoriesAndServices();
  Future<Either<Failure, List<ServiceModel>>> getServices(
      {required String categoryID});
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}
