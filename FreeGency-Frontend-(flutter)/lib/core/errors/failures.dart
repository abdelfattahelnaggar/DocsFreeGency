import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;
  const Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage});

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
            errorMessage: 'Connection timeout with the server.');
      case DioExceptionType.sendTimeout:
        return ServerFailure(errorMessage: 'Send timeout with the server.');
      case DioExceptionType.receiveTimeout:
        return ServerFailure(errorMessage: 'Receive timeout from the server.');
      case DioExceptionType.badCertificate:
        return ServerFailure(errorMessage: 'Could not verify SSL certificate.');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure(
            errorMessage: 'Request to the server was cancelled.');
      case DioExceptionType.connectionError:
        return ServerFailure(errorMessage: 'No internet connection.');
      case DioExceptionType.unknown:
        if (dioError.message?.contains('SocketException') ?? false) {
          return ServerFailure(errorMessage: 'No internet connection.');
        }
        return ServerFailure(
          errorMessage: 'Something went wrong. Please try again.',
        );
    }
  }

  // response error
  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == null) {
      return ServerFailure(
          errorMessage: "Something went wrong. No status code.");
    }

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      if (response is Map && response['errors'] is List) {
        final errors = response['errors'] as List;
        if (errors.isNotEmpty && errors[0] is Map && errors[0]['msg'] != null) {
          return ServerFailure(errorMessage: errors[0]['msg']);
        }
      }

      if (response is Map && response['message'] is String) {
        return ServerFailure(errorMessage: response['message']);
      }

      return ServerFailure(
          errorMessage: 'Authentication or permissions error.');
    } else if (statusCode == 404) {
      return ServerFailure(
          errorMessage: "Requested resource not found, please try again.");
    } else if (statusCode == 500 || statusCode == 502) {
      return ServerFailure(
          errorMessage: "Server error. Please try again later.");
    } else {
      return ServerFailure(
          errorMessage: "Oops! Something went wrong. Please try again.");
    }
  }
}
