part of 'team_profile_cubit.dart';

@immutable
sealed class TeamProfileState {}

final class TeamProfileInitial extends TeamProfileState {}

final class TeamProfileLoading extends TeamProfileState {}

final class TeamProfileSuccess extends TeamProfileState {
  final TeamsModel team;
  TeamProfileSuccess({required this.team});
}

final class TeamProfileError extends TeamProfileState {
  final String errorMessage;
  TeamProfileError({required this.errorMessage});
}

final class TeamProfileUpdateLoading extends TeamProfileState {}

final class TeamProfileUpdateSuccess extends TeamProfileState {
  final String message;
  TeamProfileUpdateSuccess({required this.message});
}

final class TeamProfileUpdateError extends TeamProfileState {
  final String errorMessage;
  TeamProfileUpdateError({required this.errorMessage});
}

final class TeamLogoUpdateLoading extends TeamProfileState {}

final class TeamLogoUpdateSuccess extends TeamProfileState {
  final String message;
  TeamLogoUpdateSuccess({required this.message});
}

final class TeamLogoUpdateError extends TeamProfileState {
  final String errorMessage;
  TeamLogoUpdateError({required this.errorMessage});
}

final class TeamProjectsLoading extends TeamProfileState {}

final class TeamProjectsSuccess extends TeamProfileState {
  final List<ProjectModel> projects;
  TeamProjectsSuccess({required this.projects});
}

final class TeamProjectsError extends TeamProfileState {
  final String errorMessage;
  TeamProjectsError({required this.errorMessage});
}

final class TeamProfileRefresh extends TeamProfileState {}
