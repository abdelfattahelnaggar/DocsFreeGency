part of 'client_home_tap_cubit.dart';

@immutable
sealed class ClientHomeTapState {}

final class ClientHomeTapInitial extends ClientHomeTapState {}

final class ClientHomeTapTopRatedLoading extends ClientHomeTapState {}

final class ClientHomeTapTopRatedSuccess extends ClientHomeTapState {
  final List<TeamsModel> teams;

  ClientHomeTapTopRatedSuccess(this.teams);
}

final class ClientHomeTapTopRatedFailure extends ClientHomeTapState {
  final String errMessage;

  ClientHomeTapTopRatedFailure(this.errMessage);
}

final class ClientHomeTapInerstedProjectsLoading extends ClientHomeTapState {}

final class ClientHomeTapInerstedProjectsSuccess extends ClientHomeTapState {
  final List<ProjectModel> projects;

  ClientHomeTapInerstedProjectsSuccess(this.projects);
}

final class ClientHomeTapInerstedProjectsFailure extends ClientHomeTapState {
  final String errMessage;

  ClientHomeTapInerstedProjectsFailure(this.errMessage);
}

// Combined states for fetching both teams and projects data
final class ClientHomeTapAllDataLoading extends ClientHomeTapState {}

final class ClientHomeTapAllDataSuccess extends ClientHomeTapState {
  final List<TeamsModel> teams;
  final List<ProjectModel> projects;

  ClientHomeTapAllDataSuccess(this.teams, this.projects);
}

final class ClientHomeTapAllDataFailure extends ClientHomeTapState {
  final String errMessage;

  ClientHomeTapAllDataFailure(this.errMessage);
}
