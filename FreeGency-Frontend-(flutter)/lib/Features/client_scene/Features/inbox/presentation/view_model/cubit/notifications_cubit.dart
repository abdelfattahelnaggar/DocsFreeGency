import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/data/model/notification_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/data/repositry/implemented_notification_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/data/repositry/notification_repo.dart';
import 'package:meta/meta.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial()) {
    fetchNotifications();
  }

  NotificationRepo implementedNotificationRepo = ImplementedNotificationRepo();

  final List<String> _filters = [
    'All',
    'Unread',
    'Read',
  ];
  String _selectedFilter = 'all';
  bool _isDropdownOpen = false;
  List<NotificationModel> notificationList = [];

  List<String> get filters => _filters;
  String get selectedFilter => _selectedFilter;
  bool get isDropdownOpen => _isDropdownOpen;

  void toggleDropdown() {
    _isDropdownOpen = !_isDropdownOpen;
    emit(NotificationsFilterChanged(_selectedFilter, _isDropdownOpen));
  }

  void setFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      _isDropdownOpen = false;
      emit(NotificationsFilterChanged(_selectedFilter, _isDropdownOpen));
      fetchFilteredNotifications(filter);
    } else {
      _isDropdownOpen = false;
      emit(NotificationsFilterChanged(_selectedFilter, _isDropdownOpen));
    }
  }

  Future<void> fetchFilteredNotifications(String filter) async {
    emit(NotificationsFilterLoading(filter));
    log('Fetching filtered notifications for: $filter');

    var result = await implementedNotificationRepo.fetchNotifications(filter);

    result.fold(
      (failure) => emit(NotificationsError(failure.errorMessage)),
      (notifications) {
        notificationList = notifications;
        emit(NotificationsLoaded(notificationList));
      },
    );
  }

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    log('Fetching initial notifications with filter: $_selectedFilter');

    var result = await implementedNotificationRepo.fetchNotifications(
      _selectedFilter,
    );

    result.fold(
      (failure) => emit(NotificationsError(failure.errorMessage)),
      (notifications) {
        notificationList = notifications;
        emit(NotificationsLoaded(notificationList));
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    emit(NotificationsLoading());
    var result = await implementedNotificationRepo.markAsRead(notificationId);
    log('Marking notification as read: $notificationId');
    result.fold(
      (failure) => emit(NotificationsError(failure.errorMessage)),
      (message) => emit(NotificationsLoaded(notificationList)),
    );
  }
}
