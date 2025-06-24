part of 'notifications_cubit.dart';

@immutable
sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsFilterChanged extends NotificationsState {
  final String selectedFilter;
  final bool isDropdownOpen;

  NotificationsFilterChanged(this.selectedFilter, this.isDropdownOpen);
}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsFilterLoading extends NotificationsState {
  final String filter;

  NotificationsFilterLoading(this.filter);
}

final class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}

final class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsLoaded(this.notifications);
}
