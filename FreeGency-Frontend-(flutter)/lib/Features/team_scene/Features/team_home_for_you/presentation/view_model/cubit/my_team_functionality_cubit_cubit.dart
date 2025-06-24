import 'package:bloc/bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/data/repositories/team_home_repo.dart';
import 'package:meta/meta.dart';

part 'my_team_functionality_cubit_state.dart';

class MyTeamFunctionalityCubitCubit
    extends Cubit<MyTeamFunctionalityCubitState> {
  MyTeamFunctionalityCubitCubit({required this.teamHomeRepo})
      : super(MyTeamFunctionalityCubitInitial());

  final TeamHomeRepo teamHomeRepo;

  List<String> savedTasksIds = [];

  Future<void> getBestMatchesTasks() async {
    emit(MyTeamFunctionalityCubitLoading());
    final result = await teamHomeRepo.getBestMatchesTasks();
    result.fold((failure) {
      emit(MyTeamFunctionalityCubitError(errorMessage: failure.errorMessage));
    }, (tasks) {
      emit(MyTeamFunctionalityCubitSuccess(tasks: tasks));
    });
  }

  Future<void> getSavedTasks() async {
    emit(MyTeamFunctionalityCubitLoading());
    final result = await teamHomeRepo.getSavedTasks();
    result.fold((failure) {
      emit(MyTeamFunctionalityCubitError(errorMessage: failure.errorMessage));
    }, (tasks) {
      savedTasksIds.clear();
      savedTasksIds.addAll(tasks.map((task) => task.id!));
      emit(MyTeamFunctionalityCubitSuccess(tasks: tasks));
    });
  }

  bool isTaskSaved(String taskId) {
    return savedTasksIds.contains(taskId);
  }

  Future<void> saveTask(String taskId) async {
    emit(SavingTaskLoading());
    var result = await teamHomeRepo.saveTask(taskId);
    result.fold(
      (failure) => emit(SavingTaskError(failure.errorMessage)),
      (message) {
        savedTasksIds.add(taskId);
        emit(SavingTaskSuccess(message));
      },
    );
  }

  Future<void> unsaveTask(String taskId) async {
    emit(SavingTaskLoading());
    var result = await teamHomeRepo.unsaveTask(taskId);
    result.fold(
      (failure) => emit(SavingTaskError(failure.errorMessage)),
      (message) {
        savedTasksIds.remove(taskId);
        emit(SavingTaskSuccess(message));
      },
    );
  }
}
