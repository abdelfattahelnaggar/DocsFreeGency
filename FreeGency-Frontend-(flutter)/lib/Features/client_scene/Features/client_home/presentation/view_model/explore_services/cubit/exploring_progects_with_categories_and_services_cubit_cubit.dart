import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/client_home_repository/client_home_tap_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';

part 'exploring_progects_with_categories_and_services_cubit_state.dart';

class ExploringProgectsWithCategoriesAndServicesCubit
    extends Cubit<ExploringProgectsWithCategoriesAndServicesState> {
  ExploringProgectsWithCategoriesAndServicesCubit(this.clientHomeTapRepo)
      : super(ExploringProgectsWithCategoriesAndServicesCubitInitial());
  final ClientHomeTapRepo clientHomeTapRepo;

  Future<void> getProjectByCategoryOrService(String path) async {
    emit(ExploringProgectsWithCategoriesAndServicesCubitLoading());
    try {
  final result = await clientHomeTapRepo.getProjectByCategoryOrService(path);
  result.fold((failure) {
    emit(ExploringProgectsWithCategoriesAndServicesCubitFailure(
        failure.errorMessage));
  }, (projects) {
        emit(ExploringProgectsWithCategoriesAndServicesCubitSuccess(projects));
      });
    } catch (e) {
      emit(ExploringProgectsWithCategoriesAndServicesCubitFailure(e.toString()));
    }
  }
}
