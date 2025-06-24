import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/view_model/cubit/notifications_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/widgets/notification_item.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';

class NotificationsListView extends StatelessWidget {
  const NotificationsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final cubit = context.read<NotificationsCubit>();

          // Initial loading state (only when there's no data yet)
          if (state is NotificationsLoading && cubit.notificationList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NotificationsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => cubit.fetchNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final notifications = cubit.notificationList;

          if (notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await cubit.fetchNotifications();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(
                    child: Text(
                      'No notifications found',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            );
          }

          // Show list with appropriate loading indicator
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await cubit.fetchNotifications();
                },
                child: ListView.builder(
                  itemCount: notifications.length,
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NotificationItem(
                        notification: notification,
                      ),
                    );
                  },
                ),
              ),
              // Show linear progress indicator for filter loading
              if (state is NotificationsFilterLoading)
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withValues(alpha: 0.8),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            ReusableTextStyleMethods.poppins16RegularMethod(
                                context:context,
                                text:
                                    "Loading ${(state).filter} notifications..."),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              // Show linear progress indicator for regular loading
              if (state is NotificationsLoading &&
                  cubit.notificationList.isNotEmpty)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 4.h,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
