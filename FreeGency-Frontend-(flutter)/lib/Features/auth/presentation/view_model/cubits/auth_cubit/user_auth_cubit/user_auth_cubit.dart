import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_login_request_model.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_register_request.dart';
import 'package:freegency_gp/Features/auth/data/repositories/user_auth_repository.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_state.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/fcm_services.dart';

class UserAuthCubit extends Cubit<UserAuthStates> {
  final UserAuthRepository _authRepository;
  final FCMServices _fcmServices = FCMServices();

  UserAuthCubit({UserAuthRepository? authRepository})
      : _authRepository = authRepository ?? UserAuthRepository(),
        super(AuthInitial());

  String? otpCode;

  Future<void> userRegister(UserRegisterRequest userRegisterRequest) async {
    emit(UserAuthLoading());

    try {
      final userResponse = await _authRepository.register(userRegisterRequest);
      await LocalStorage.setToken(userResponse.token);
      await LocalStorage.setUserData(userResponse.user);

      // After successful registration, always navigate to interests for clients
      final isClient = await LocalStorage.isClient();
      if (isClient) {
        emit(UserAuthSuccess(nextRoute: AppRoutes.chooseInterests));
      } else {
        emit(UserAuthSuccess(nextRoute: AppRoutes.clientHome));
      }
    } catch (error) {
      emit(UserAuthError(error.toString()));
    }
  }

  Future<void> userLogin(UserLoginRequestModel userLoginRequest) async {
    emit(UserAuthLoading());
    try {
      // Get FCM token for notifications
      final fcmToken = await _fcmServices.getFCMToken();

      // Create a new request with the FCM token
      final loginRequestWithToken = UserLoginRequestModel(
        email: userLoginRequest.email,
        password: userLoginRequest.password,
        fcmToken: fcmToken,
      );

      final userResponse = await _authRepository.login(loginRequestWithToken);
      await LocalStorage.setToken(userResponse.token);
      await LocalStorage.setUserData(userResponse.user);

      // After successful login, navigate directly to home based on role
      await _navigateBasedOnRole(isLogin: true);
    } catch (error) {
      emit(UserAuthError(error.toString()));
    }
  }

  // Helper method to navigate based on user role
  Future<void> _navigateBasedOnRole({bool isLogin = false}) async {
    final isClient = await LocalStorage.isClient();

    if (isClient) {
      if (isLogin) {
        // For clients logging in, navigate directly to home
        emit(UserAuthSuccess(nextRoute: AppRoutes.clientHome));
      } else {
        // For clients registering, navigate to interests selection
        emit(UserAuthSuccess(nextRoute: AppRoutes.chooseInterests));
      }
    } else {
      // For team leaders, navigate to leader home
      emit(UserAuthSuccess(nextRoute: AppRoutes.clientHome));
    }
  }

  Future<void> verifyEmail(String resetCode) async {
    emit(UserAuthVerifyEmailLoading());

    try {
      await _authRepository.verifyEmail(resetCode);
      emit(UserAuthVerifyEmailSuccess());
    } catch (error) {
      emit(UserAuthVerifyEmailError(error.toString()));
    }
  }

  Future<void> forgetPassword(String email) async {
    emit(UserAuthForgetPasswordLoading());

    try {
      await _authRepository.forgetPassword(email);
      emit(UserAuthForgetPasswordSuccess());
    } catch (error) {
      emit(UserAuthForgetPasswordError(error.toString()));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    emit(UserAuthResetPasswordLoading());

    try {
      await _authRepository.resetPassword(
        email: email,
        newPassword: newPassword,
      );
      emit(UserAuthResetPasswordSuccess());
    } catch (error) {
      emit(UserAuthResetPasswordError(error.toString()));
    }
  }

  Future<void> logout() async {
    await LocalStorage.clearAuthData();
    emit(AuthInitial());
  }
}
