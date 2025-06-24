part of 'user_data_functionality_cubit.dart';

class UserDataFunctionalityState {}

final class UserDataFunctionalityInitial extends UserDataFunctionalityState {}

final class GetUserDataLoading extends UserDataFunctionalityState {}

final class GetUserDataSuccess extends UserDataFunctionalityState {
  final UserModel userModel;
  GetUserDataSuccess(this.userModel);
}

final class GetUserDataError extends UserDataFunctionalityState {
  final String errorMessage;
  GetUserDataError(this.errorMessage);
}

final class UploadImageLoading extends UserDataFunctionalityState {}

final class UploadImageSuccess extends UserDataFunctionalityState {}

final class UploadImageError extends UserDataFunctionalityState {
  final String errorMessage;
  UploadImageError(this.errorMessage);
}

final class GetMyTasksLoading extends UserDataFunctionalityState {}

final class GetMyTasksSuccess extends UserDataFunctionalityState {
  final MyTasksResponseModel myTasksModel;
  GetMyTasksSuccess(this.myTasksModel);
}

final class GetMyTasksError extends UserDataFunctionalityState {
  final String errorMessage;
  GetMyTasksError(this.errorMessage);
}

// Combined states for fetching both user and tasks data
final class GetAllUserDataLoading extends UserDataFunctionalityState {}

final class GetAllUserDataSuccess extends UserDataFunctionalityState {
  final UserModel userModel;
  final MyTasksResponseModel tasksModel;

  GetAllUserDataSuccess(this.userModel, this.tasksModel);
}

final class GetAllUserDataError extends UserDataFunctionalityState {
  final String errorMessage;
  GetAllUserDataError(this.errorMessage);
}

final class UpdateUserDataLoading extends UserDataFunctionalityState {}

final class UpdateUserDataSuccess extends UserDataFunctionalityState {
  final UserModel userModel;
  UpdateUserDataSuccess(this.userModel);
}

final class UpdateUserDataError extends UserDataFunctionalityState {
  final String errorMessage;
  UpdateUserDataError(this.errorMessage);
}

final class PasswordChanging extends UserDataFunctionalityState {}

final class PasswordChanged extends UserDataFunctionalityState {}

final class PasswordChangeError extends UserDataFunctionalityState {
  final String message;
  PasswordChangeError(this.message);
}
