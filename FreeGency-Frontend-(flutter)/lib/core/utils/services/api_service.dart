import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:freegency_gp/core/errors/failures.dart';

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();
  static Dio _dio = Dio();

  static const String apiBaseUrl =
      "https://free-gency-backend-003bbc67b812.herokuapp.com/api/v1/";

  static void dioInit() {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
      ),
    );
  }

  Future<Map<String, dynamic>> getData({
    required String path,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(path, data: body, options: options);

      return response.data;
    } catch (e) {
      log('API Post Error: $e');
      if (e is DioException) {
        throw ServerFailure.fromDioError(e);
      } else {
        throw ServerFailure(errorMessage: 'Unexpected error: $e');
      }
    }
  }

  Future<Map<String, dynamic>> postData({
    required String path,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(path, data: body, options: options);
      return response.data;
    } catch (e) {
      log('API Post Error: $e');
      if (e is DioException) {
        throw ServerFailure.fromDioError(e);
      } else {
        throw ServerFailure(errorMessage: 'Unexpected error: $e');
      }
    }
  }

  Future<Map<String, dynamic>> patchData({
    required String path,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(path, data: body, options: options);
      return response.data;
    } catch (e) {
      log('API Patch Error: $e');
      if (e is DioException) {
        throw ServerFailure.fromDioError(e);
      } else {
        throw ServerFailure(errorMessage: 'Unexpected error: $e');
      }
    }
  }

  Future<Map<String, dynamic>> deleteData({
    required String path,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(path, data: body, options: options);
      return response.data;
    } catch (e) {
      log('API Delete Error: $e');
      if (e is DioException) {
        throw ServerFailure.fromDioError(e);
      } else {
        throw ServerFailure(errorMessage: 'Unexpected error: $e');
      }
    }
  }
}
