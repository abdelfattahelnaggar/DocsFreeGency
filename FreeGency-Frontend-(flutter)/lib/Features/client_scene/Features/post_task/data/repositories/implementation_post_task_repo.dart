import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/models/post_task_request_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/models/post_task_response_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/repositories/post_task_repo.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:http_parser/http_parser.dart';

class PostTaskRepoImplementation extends PostTaskRepo {
  @override
  Future<Either<Failure, File>> chooseFileFromDevice() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png', 'zip', 'jpeg'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        log('✅ File Name: ${result.files.single.name}');
        log('📁 File Path: ${file.path}');
        log('📦 File Size: ${result.files.single.size} bytes');

        return right(file);
      } else {
        log('❌ No file selected');
        return left(ServerFailure(errorMessage: 'No file selected!'));
      }
    } catch (e, stackTrace) {
      log('❌ Exception: $e\n$stackTrace');
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postTask(
      PostTaskRequestModel postTaskRequestModel) async {
    try {
      log('🔄 Starting task post process...');
      final token = await LocalStorage.getToken();
      log('🔑 Token retrieved: ${token != null ? 'Present' : 'Missing'}');

      final formData = FormData.fromMap({
        'title': postTaskRequestModel.title,
        'description': postTaskRequestModel.description,
        'budget': postTaskRequestModel.budget,
        'requiredSkills[]': postTaskRequestModel.requiredSkills,
        'category': postTaskRequestModel.category,
        'service': postTaskRequestModel.service,
        'deadline': postTaskRequestModel.deadline.toIso8601String(),
        'isFixedPrice': postTaskRequestModel.isFixedPrice,
        if (postTaskRequestModel.relatedFile != null)
          'requirment': await MultipartFile.fromFile(
            postTaskRequestModel.relatedFile!.path,
            filename: postTaskRequestModel.relatedFile!.path.split('/').last,
            contentType: MediaType.parse('application/octet-stream'),
          ),
      });

      log('================================= formData: ${formData.fields}');

      if (postTaskRequestModel.relatedFile != null) {
        log('   File Path: ${postTaskRequestModel.relatedFile!.path}');
        log('   File Name: ${postTaskRequestModel.relatedFile!.path.split('/').last}');
      }

      const url =
          '${ApiConstants.baseUrl}/api/v1/${ApiConstants.postTaskEndPoint}';
      log('🌐 Making request to: $url');

      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.sendTimeout = const Duration(seconds: 30);

      try {
        final response = await dio.post(
          url,
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
            validateStatus: (status) => status! < 500,
          ),
          onSendProgress: (int sent, int total) {
            log('📤 Upload progress: ${(sent / total * 100).toStringAsFixed(2)}%');
          },
        );

        log('✅ Response received: ${response.statusCode}');
        log('📄 Response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final postTaskModel = PostTaskResponseModel.fromJson(response.data);
          return right(postTaskModel);
        } else {
          log('❌ Server returned error status: ${response.statusCode}');
          log('❌ Error details: ${response.data}');
          return left(ServerFailure(
            errorMessage: response.data['message'] ??
                'Server returned status code: ${response.statusCode}',
          ));
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          return left(ServerFailure(
            errorMessage:
                'Request timed out. Please check your internet connection and try again.',
          ));
        }

        return left(ServerFailure.fromDioError(e));
      } catch (e) {
        log('❌ Unexpected Error: $e');
        return left(ServerFailure(errorMessage: e.toString()));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        log('❌ Failure Error: $e');
        return left(e);
      } else {
        log('❌ Unexpected Error: $e');
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
}
