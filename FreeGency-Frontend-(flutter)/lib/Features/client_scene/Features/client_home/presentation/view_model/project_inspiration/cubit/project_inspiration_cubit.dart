import 'package:bloc/bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/client_home_repository/client_home_tap_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:meta/meta.dart';

part 'project_inspiration_state.dart';

class ProjectInspirationCubit extends Cubit<ProjectInspirationState> {
  ProjectInspirationCubit(this.clientHomeTapRepo)
      : super(ProjectInspirationInitial());

  final ClientHomeTapRepo clientHomeTapRepo;
  bool _isClosed = false;

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  Future<void> getProjectInspirationData(String projectId) async {
    if (_isClosed) return;

    emit(ProjectInspirationDataLoading());

    try {
    final result = await clientHomeTapRepo.getSpecificProject(projectId);

      if (_isClosed) return;

    result.fold(
        (failure) => emit(ProjectInspirationDataError(failure: failure)),
        (projectModel) =>
            emit(ProjectInspirationDataLoaded(projectModel: projectModel)));
    } catch (e) {
      if (!_isClosed) {
        emit(ProjectInspirationDataError(
            failure: ServerFailure(errorMessage: e.toString())));
      }
    }
  }
}
