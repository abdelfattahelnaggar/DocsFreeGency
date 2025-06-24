import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/data/post_project_request_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/data/post_project_response_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/repositories/post_project_repo.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:http_parser/http_parser.dart';

class PostProjectRepoImplementation extends PostProjectRepo {
  @override
  Future<Either<Failure, List<File>>> chooseImagesFromDevice() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
      );

      if (result != null && result.files.isNotEmpty) {
        List<File> files = [];

        for (var file in result.files) {
          if (file.path != null) {
            files.add(File(file.path!));
            log('✅ Image Selected: ${file.name}');
            log('📁 Image Path: ${file.path}');
            log('📦 Image Size: ${file.size} bytes');
          }
        }

        if (files.isNotEmpty) {
          log('✅ Total ${files.length} images selected');
          return right(files);
        } else {
          log('❌ No valid images found');
          return left(ServerFailure(errorMessage: 'No valid images selected!'));
        }
      } else {
        log('❌ No images selected');
        return left(ServerFailure(errorMessage: 'No images selected!'));
      }
    } catch (e, stackTrace) {
      log('❌ Exception: $e\n$stackTrace');
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostProjectResponseModel>> postProject(
      PostProjectRequestModel postProjectRequestModel) async {
    try {
      log('🔄 Starting project post process...');
      final token = await LocalStorage.getToken();
      log('🔑 Token retrieved: ${token != null ? 'Present' : 'Missing'}');

      final formData = FormData.fromMap({
        'title': postProjectRequestModel.title,
        'description': postProjectRequestModel.description,
        'budget': postProjectRequestModel.budget,
        'projectUrl': postProjectRequestModel.projectUrl,
        'technologies': postProjectRequestModel.technologies,
        'completionDate':
            postProjectRequestModel.completionDate.toIso8601String(),
        'service': postProjectRequestModel.service,
      });

      // Add multiple images if provided
      if (postProjectRequestModel.hasImages) {
        for (int i = 0; i < postProjectRequestModel.images!.length; i++) {
          final image = postProjectRequestModel.images![i];
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
              contentType: MediaType.parse('image/jpeg'),
            ),
          ));
          log('📷 Added image ${i + 1}: ${image.path.split('/').last}');
        }
      }

      log('================================= formData: ${formData.fields}');
      log('================================= images count: ${formData.files.length}');

      const url =
          '${ApiConstants.baseUrl}/api/v1/${ApiConstants.projectsEndPoint}';
      log('🌐 Making request to: $url');

      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.sendTimeout =
          const Duration(seconds: 60); // Longer timeout for multiple images

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
          final postProjectModel =
              PostProjectResponseModel.fromJson(response.data);
          return right(postProjectModel);
        } else {
          log('❌ Server returned error status: ${response.statusCode}');
          log('❌ Error details: ${response.data}');

          // Handle validation errors
          final errorResponse =
              PostProjectResponseModel.fromJson(response.data);
          return left(ServerFailure(
            errorMessage: errorResponse.hasErrors
                ? errorResponse.errorMessage
                : 'Server returned status code: ${response.statusCode}',
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
