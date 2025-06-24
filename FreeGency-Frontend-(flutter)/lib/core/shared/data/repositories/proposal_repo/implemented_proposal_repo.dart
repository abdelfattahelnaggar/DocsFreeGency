import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/shared/data/models/proposal_model.dart';
import 'package:freegency_gp/core/shared/data/repositories/proposal_repo/proposal_repository.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

class ImplementedProposalRepository extends ProposalRepository {
  @override
  Future<Either<Failure, ProposalModel>> getProposalById(
      String proposalId) async {
    log('=-=---=--=-=-==-==--=-=-=--= $proposalId');
    try {
      final token = await LocalStorage.getToken();
      log('===========================$token');
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.specificProposalEndPoint}/$proposalId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('3434343434343432434324324324-=-=--=-- : ${response.toString()}');
      log(response['data'].toString());
      final proposalModel = ProposalModel.fromJson(response['data']);
      log(proposalModel.toString());
      return right(proposalModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> acceptTeamRequest(String teamRequestId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.patchData(
        path: '${ApiConstants.specificProposalEndPoint}/$teamRequestId/accept',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('A7A A7A A7A =-=--=--: ${response['data']}');
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> submitProposal({
    required String taskId,
    required String note,
    required int budget,
    String? similarProjectUrl,
    List<Map<String, dynamic>>? proposalFiles,
  }) async {
    try {
      log('🔄 Starting proposal submission...');
      final token = await LocalStorage.getToken();
      log('🔑 Token retrieved: ${token != null ? 'Present' : 'Missing'}');

      final formData = FormData();

      formData.fields.add(MapEntry('note', note));
      formData.fields.add(MapEntry('budget', budget.toString()));

      if (similarProjectUrl != null && similarProjectUrl.isNotEmpty) {
        formData.fields.add(MapEntry('similarProjectUrl', similarProjectUrl));
      }

      if (proposalFiles != null && proposalFiles.isNotEmpty) {
        for (var i = 0; i < proposalFiles.length; i++) {
          final fileMap = proposalFiles[i];
          final filePath = fileMap['fileUrl'];
          final fileName = fileMap['fileName'];

          if (filePath != null) {
            final file = File(filePath);
            if (await file.exists()) {
              formData.files.add(
                MapEntry(
                  'proposal',
                  await MultipartFile.fromFile(
                    file.path,
                    filename: fileName ?? file.path.split('/').last,
                    contentType: MediaType.parse('application/octet-stream'),
                  ),
                ),
              );
              log('📎 Adding file: $fileName');
            }
          }
        }
      }

      final path = '${ApiConstants.specificTaskEndPoint}/$taskId/requests';
      log('🌐 Making request to endpoint: $path');

      final dio = Dio();
      dio.options.baseUrl = ApiService.apiBaseUrl;

      try {
        final response = await dio.post(
          path,
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
          ),
          onSendProgress: (int sent, int total) {
            log('📤 Upload progress: ${(sent / total * 100).toStringAsFixed(2)}%');
          },
        );

        log('✅ Response received: ${response.statusCode}');
        log('📄 Response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return right(null);
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
      }
    } catch (e) {
      log('❌ Unexpected Error: $e');
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else if (e is Failure) {
        return left(e);
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
}
