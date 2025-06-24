part of 'get_categories_and_services_cubit.dart';

@immutable
sealed class GetCategoriesAndServicesState {}

final class GetCategoriesAndServicesInitial
    extends GetCategoriesAndServicesState {}

final class GetCategoriesAndServicesSuccess
    extends GetCategoriesAndServicesState {
  final dynamic data;

  GetCategoriesAndServicesSuccess({required this.data});
}

final class GetCategoriesAndServicesError
    extends GetCategoriesAndServicesState {
  final String errorMessage;

  GetCategoriesAndServicesError({required this.errorMessage});
}

final class GetCategoriesAndServicesLoading
    extends GetCategoriesAndServicesState {}
