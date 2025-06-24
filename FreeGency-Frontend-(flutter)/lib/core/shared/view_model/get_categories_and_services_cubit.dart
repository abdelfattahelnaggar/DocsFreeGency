import 'package:bloc/bloc.dart';
import 'package:freegency_gp/core/shared/data/repositories/categories_and_services_repositories/categories_and_services_repositories.dart';
import 'package:meta/meta.dart';

part 'get_categories_and_services_state.dart';

class GetCategoriesAndServicesCubit
    extends Cubit<GetCategoriesAndServicesState> {
  GetCategoriesAndServicesCubit(this.categoriesAndServicesRepositories)
      : super(GetCategoriesAndServicesInitial());

  String? selectedCategory;
  String? selectedService;
  String? selectedCategoryId;
  String? selectedServiceId;

  final CategoriesAndServicesRepositories categoriesAndServicesRepositories;

  void clearSelection() {
    selectedCategory = null;
    selectedService = null;
    selectedCategoryId = null;
    selectedServiceId = null;
  }

  Future<void> fetchCategories() async {
    emit(GetCategoriesAndServicesLoading());

    final result = await categoriesAndServicesRepositories.getCategories();

    result.fold(
      (failure) => emit(
          GetCategoriesAndServicesError(errorMessage: failure.errorMessage)),
      (data) => emit(GetCategoriesAndServicesSuccess(data: data)), // List
    );
  }

  Future<void> fetchServicesByCategory(String categoryId) async {
    emit(GetCategoriesAndServicesLoading());

    final result = await categoriesAndServicesRepositories.getServices(
        categoryID: categoryId);

    result.fold(
      (failure) => emit(
          GetCategoriesAndServicesError(errorMessage: failure.errorMessage)),
      (data) => emit(GetCategoriesAndServicesSuccess(data: data)), // List
    );
  }

  Future<void> fetchCategoriesAndServicesModel() async {
    emit(GetCategoriesAndServicesLoading());

    final result =
        await categoriesAndServicesRepositories.getCategoriesAndServices();

    result.fold(
      (failure) => emit(
          GetCategoriesAndServicesError(errorMessage: failure.errorMessage)),
      (data) => emit(GetCategoriesAndServicesSuccess(data: data)), // Model
    );
  }
}
