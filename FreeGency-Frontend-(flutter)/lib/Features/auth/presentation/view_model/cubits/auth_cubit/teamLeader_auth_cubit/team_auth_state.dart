import 'package:freegency_gp/Features/auth/data/models/client_models/userr_response_model.dart';
import 'package:freegency_gp/Features/auth/data/models/teams_models/team_register_response_model.dart';

abstract class TeamAuthState {}

final class TeamAuthStateInitial extends TeamAuthState {}

final class TeamAuthStateLoading extends TeamAuthState {}

final class TeamAuthStateSuccess extends TeamAuthState {
  final UserResponseModel? data;

  TeamAuthStateSuccess(this.data);
}

final class TeamAuthRegisterStateSuccess extends TeamAuthState {
  final TeamRegisterOrCreateResponseModel? data;

  TeamAuthRegisterStateSuccess(this.data);
}

final class TeamAuthStateError extends TeamAuthState {
  final String errMessage;

  TeamAuthStateError(this.errMessage);
}
