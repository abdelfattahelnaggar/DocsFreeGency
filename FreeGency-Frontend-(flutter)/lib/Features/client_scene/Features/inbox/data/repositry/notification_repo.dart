import 'package:dartz/dartz.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/data/model/notification_model.dart';
import 'package:freegency_gp/core/errors/failures.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationModel>>> fetchNotifications(String filter);
  Future<Either<Failure, String>> markAsRead(String notificationId);
}
