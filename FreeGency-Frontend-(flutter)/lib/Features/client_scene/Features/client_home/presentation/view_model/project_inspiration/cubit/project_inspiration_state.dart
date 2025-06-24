part of 'project_inspiration_cubit.dart';

@immutable
sealed class ProjectInspirationState {}

final class ProjectInspirationInitial extends ProjectInspirationState {}
final class ProjectInspirationDataLoaded extends ProjectInspirationState {
  final ProjectModel projectModel;
  ProjectInspirationDataLoaded({required this.projectModel});
}
final class ProjectInspirationDataLoading extends ProjectInspirationState {}
final class ProjectInspirationDataError extends ProjectInspirationState {
  final Failure failure;
  ProjectInspirationDataError({required this.failure});
}