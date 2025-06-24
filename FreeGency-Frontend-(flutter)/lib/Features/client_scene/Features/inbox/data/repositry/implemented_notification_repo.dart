import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/data/model/notification_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/data/repositry/notification_repo.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/utils/constants/apis.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';

class ImplementedNotificationRepo extends NotificationRepo {
  @override
  Future<Either<Failure, List<NotificationModel>>> fetchNotifications(
    String filter,
  ) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.getData(
        path: '${ApiConstants.myNotification}?filterBy=$filter',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List<NotificationModel> notifications =
          List<NotificationModel>.from(
        response['data'].map((x) => NotificationModel.fromJson(x)),
      );

      return right(notifications);
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
  Future<Either<Failure, String>> markAsRead(String notificationId) async {
    try {
      final token = await LocalStorage.getToken();
      final response = await ApiService.instance.patchData(
        path: '${ApiConstants.myNotification}/$notificationId/read',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return right(response['message'] ?? 'Notification marked as read');
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
}
