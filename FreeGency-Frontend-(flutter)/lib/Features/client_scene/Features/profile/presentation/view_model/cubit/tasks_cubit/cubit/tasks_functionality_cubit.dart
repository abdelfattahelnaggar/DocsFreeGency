import 'package:bloc/bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_team_requestes_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/repositories/Tasks_Repo/tasks_repository.dart';
import 'package:meta/meta.dart';

part 'tasks_functionality_state.dart';

class TasksFunctionalityCubit extends Cubit<TasksFunctionalityState> {
  TasksFunctionalityCubit(this.tasksRepo) : super(TasksFunctionalityInitial());
  TasksRepository tasksRepo;

  Future<void> getTaskById(String id) async {
    emit(GetTaskByIdLoading());
    var result = await tasksRepo.getTaskById(id);

    result.fold(
      (failure) => emit(GetTaskByIdError(failure.errorMessage)),
      (task) => emit(GetTaskByIdSuccess(task)),
    );
  }  
  Future<void> getTaskRequests(String id) async {
    emit(GetTaskRequestsLoading());
    var result = await tasksRepo.getTaskRequests(id);
    result.fold(
      (failure) => emit(GetTaskRequestsError(failure.errorMessage)),
      (taskRequests) => emit(GetTaskRequestsSuccess(taskRequests)),
    );
  }

  
}
