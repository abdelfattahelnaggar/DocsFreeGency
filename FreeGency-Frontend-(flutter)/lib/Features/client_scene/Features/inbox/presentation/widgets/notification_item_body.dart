import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/data/model/notification_model.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class NotificationItemBody extends StatelessWidget {
  const NotificationItemBody({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppBarTheme.of(context).backgroundColor!.withValues(alpha: 0.35)
            : AppBarTheme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppBarTheme.of(context).backgroundColor,
            backgroundImage: notification.imageUrl.isNotEmpty
                ? NetworkImage(notification.imageUrl)
                : null,
            child: notification.imageUrl.isEmpty
                ? Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 24,
                  )
                : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppTextStyles.poppins16Bold(context),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      notification.timeAgo,
                      style: AppTextStyles.poppins12Regular(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.body,
                  style: AppTextStyles.poppins14Regular(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
