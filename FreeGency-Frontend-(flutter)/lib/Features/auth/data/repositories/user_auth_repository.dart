import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_login_request_model.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/user_register_request.dart';
import 'package:freegency_gp/Features/auth/data/models/client_models/userr_response_model.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';

class UserAuthRepository {
  final Dio _dio;

  UserAuthRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                validateStatus: (statusCode) => true,
              ),
            );

  Future<UserResponseModel> register(UserRegisterRequest request) async {
    final response = await _dio.post(
      ApiConstants.userRegisterEndPoint,
      data: request.toJson(),
    );

    if (response.statusCode == 201) {
      return UserResponseModel.fromJson(response.data);
    } else if (response.statusCode == 400) {
      throw Exception(
          response.data['errors']?.map((e) => e['msg'] as String).toList());
    } else {
      throw Exception(response.data['message'] ?? 'Registration failed');
    }
  }

  Future<UserResponseModel> login(UserLoginRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.userLoginEndPoint,
      data: request.toJson(),
    );

    if (response.statusCode == 200) {
      return UserResponseModel.fromJson(response.data);
    } else if (response.statusCode == 400) {
      throw Exception(response.data['message']);
    } else {
      throw Exception(response.data['message'] ?? 'Login failed');
    }
  }

  Future<void> verifyEmail(String resetCode) async {
    final response = await _dio.post(
      ApiConstants.verifyEmailEndPoint,
      data: {'resetCode': resetCode},
    );
    final message = response.data['message'] as String?;
    if (response.statusCode != 200) {
      throw Exception(message ?? 'Email verification failed');
    }
  }

  Future<void> forgetPassword(String email) async {
    final response = await _dio.post(
      ApiConstants.forgetPasswordEndPoint,
      data: {'email': email},
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        final errorMessages =
            response.data['errors']?.map((e) => e['msg'] as String).toList();
        throw Exception(errorMessages);
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error occurred');
      }
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await _dio.post(
      ApiConstants.resetPasswordEndPoint,
      data: {
        'email': email,
        'newPassword': newPassword,
      },
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        final errorMessages =
            response.data['message'] ?? 'Reset password failed';
        throw Exception(errorMessages);
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error occurred');
      }
    }
  }
}
