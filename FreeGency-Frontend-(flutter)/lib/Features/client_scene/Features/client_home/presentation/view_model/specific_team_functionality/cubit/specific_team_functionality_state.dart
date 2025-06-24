part of 'specific_team_functionality_cubit.dart';

@immutable
sealed class SpecificTeamFunctionalityState {}

final class SpecificTeamFunctionalityInitial extends SpecificTeamFunctionalityState {}

final class SpecificTeamFunctionalityLoading extends SpecificTeamFunctionalityState {}

final class SpecificTeamFunctionalityLoaded extends SpecificTeamFunctionalityState {
  final TeamsModel team;

  SpecificTeamFunctionalityLoaded({required this.team});
}

final class SpecificTeamFunctionalityError extends SpecificTeamFunctionalityState {
  final String error;

  SpecificTeamFunctionalityError({required this.error});
}
