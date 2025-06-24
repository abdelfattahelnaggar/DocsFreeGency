part of 'join_team_cubit.dart';

@immutable
sealed class JoinTeamState {}

final class JoinTeamInitial extends JoinTeamState {}

final class JoinTeamLoading extends JoinTeamState {}

final class JoinTeamSuccess extends JoinTeamState {
  final String message;
  JoinTeamSuccess({required this.message});
}

final class JoinTeamError extends JoinTeamState {
  final String errorMessage;
  JoinTeamError({required this.errorMessage});
}

final class GetSpecificJoinRequestLoading extends JoinTeamState {}

final class GetSpecificJoinRequestSuccess extends JoinTeamState {
  final JoinTeamResponseModel joinTeamResponseModel;
  GetSpecificJoinRequestSuccess({required this.joinTeamResponseModel});
}

final class GetSpecificJoinRequestError extends JoinTeamState {
  final String errorMessage;
  GetSpecificJoinRequestError({required this.errorMessage});
}
