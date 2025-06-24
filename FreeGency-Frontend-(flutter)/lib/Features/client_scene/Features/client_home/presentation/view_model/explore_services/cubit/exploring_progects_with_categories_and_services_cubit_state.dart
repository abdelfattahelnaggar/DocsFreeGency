part of 'exploring_progects_with_categories_and_services_cubit_cubit.dart';


abstract class ExploringProgectsWithCategoriesAndServicesState {}

final class ExploringProgectsWithCategoriesAndServicesCubitInitial
    extends ExploringProgectsWithCategoriesAndServicesState {}

final class ExploringProgectsWithCategoriesAndServicesCubitLoading
    extends ExploringProgectsWithCategoriesAndServicesState {}

final class ExploringProgectsWithCategoriesAndServicesCubitSuccess
    extends ExploringProgectsWithCategoriesAndServicesState {
  final List<ProjectModel> projects;
  ExploringProgectsWithCategoriesAndServicesCubitSuccess(this.projects);
}

final class ExploringProgectsWithCategoriesAndServicesCubitFailure
    extends ExploringProgectsWithCategoriesAndServicesState {
  final String errorMessage;
  ExploringProgectsWithCategoriesAndServicesCubitFailure(this.errorMessage);
}
