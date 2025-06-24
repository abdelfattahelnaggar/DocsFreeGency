import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/models/join_team_request_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/models/join_team_response_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/repositories/join_team_repo.dart';

part 'join_team_state.dart';

class JoinTeamCubit extends Cubit<JoinTeamState> {
  JoinTeamCubit({required this.joinTeamRepo}) : super(JoinTeamInitial());

  final JoinTeamRepo joinTeamRepo;
  final TextEditingController teamCodeController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  Future<void> sendJoinRequest() async {
    if (teamCodeController.text.trim().isEmpty) {
      emit(JoinTeamError(errorMessage: 'Please enter a team code'));
      return;
    }

    emit(JoinTeamLoading());

    final result = await joinTeamRepo.sendJoinRequest(
      JoinTeamRequestModel(
        teamCode: teamCodeController.text.trim(),
        job: jobController.text.trim(),
      ),
    );
    result.fold(
      (failure) => emit(JoinTeamError(errorMessage: failure.errorMessage)),
      (message) => emit(JoinTeamSuccess(message: message)),
    );
  }

  Future<void> acceptJoinRequest(String requestId) async {
    emit(JoinTeamLoading());
    final result = await joinTeamRepo.acceptJoinRequest(requestId);
    result.fold(
      (failure) => emit(JoinTeamError(errorMessage: failure.errorMessage)),
      (message) => emit(JoinTeamSuccess(message: message)),
    );
  }

  Future<void> rejectJoinRequest(String requestId) async {
    emit(JoinTeamLoading());
    final result = await joinTeamRepo.rejectJoinRequest(requestId);
    result.fold(
      (failure) => emit(JoinTeamError(errorMessage: failure.errorMessage)),
      (message) => emit(JoinTeamSuccess(message: message)),
    );
  }

  Future<void> getSpecificJoinRequest(String requestId) async {
    emit(GetSpecificJoinRequestLoading());
    final result = await joinTeamRepo.getSpecificJoinRequest(requestId);
    result.fold(
      (failure) => emit(GetSpecificJoinRequestError(errorMessage: failure.errorMessage)),
      (message) => emit(GetSpecificJoinRequestSuccess(joinTeamResponseModel: message)),
    );
  }

  void clearForm() {
    teamCodeController.clear();
    jobController.clear();
    emit(JoinTeamInitial());
  }

  @override
  Future<void> close() {
    teamCodeController.dispose();
    jobController.dispose();
    return super.close();
  }
}
