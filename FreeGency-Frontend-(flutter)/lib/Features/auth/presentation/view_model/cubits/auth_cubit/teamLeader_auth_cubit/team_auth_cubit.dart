import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_login_request_model.dart';
import 'package:freegency_gp/Features/auth/data/models/teams_models/team_register_request_model.dart';
import 'package:freegency_gp/Features/auth/data/repositories/team_leader_auth_repo.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/teamLeader_auth_cubit/team_auth_state.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/fcm_services.dart';

class TeamAuthCubit extends Cubit<TeamAuthState> {
  TeamAuthCubit(this.teamLeaderAuthRepo) : super(TeamAuthStateInitial());

  final TeamLeaderAuthRepo teamLeaderAuthRepo;
  final FCMServices _fcmServices = FCMServices();

  Future<void> teamLogin(
      {required UserLoginRequestModel userLoginRequest}) async {
    emit(TeamAuthStateLoading());

    try {
      // Get FCM token for notifications
      final fcmToken = await _fcmServices.getFCMToken();

      // Create a new request with the FCM token
      final loginRequestWithToken = UserLoginRequestModel(
        email: userLoginRequest.email,
        password: userLoginRequest.password,
        fcmToken: fcmToken,
      );

      var result =
          await teamLeaderAuthRepo.teamLeaderLogin(loginRequestWithToken);

      result.fold((failure) {
        log('AUTH ERROR: ${failure.errorMessage}');
        emit(TeamAuthStateError(failure.errorMessage));
      }, (model) async {
        await LocalStorage.setToken(model.token);
        await LocalStorage.setUserData(model.user);
        emit(TeamAuthStateSuccess(model));
      });
    } catch (e) {
      emit(TeamAuthStateError(e.toString()));
    }
  }

  Future<void> teamCreateOrRegister(
      {required TeamRegisterOrCreateRequestModel
          teamRegisterOrCreateRequestModel}) async {
    emit(TeamAuthStateLoading());

    try {
      var result = await teamLeaderAuthRepo
          .teamLeaderCreateTeam(teamRegisterOrCreateRequestModel);

      result.fold((failure) {
        emit(TeamAuthStateError(failure.errorMessage));
      }, (model) {
        emit(TeamAuthRegisterStateSuccess(model));
      });
    } catch (e) {
      emit(TeamAuthStateError(e.toString()));
    }
  }
}
