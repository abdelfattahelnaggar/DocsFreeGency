import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/data/model/notification_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/view_model/cubit/notifications_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/widgets/join_team_dialog.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/widgets/notification_item_body.dart';
import 'package:freegency_gp/Features/home/presentation/view_model/cubits/change_btn_nav_bar/change_btn_nav_bar_cubit.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/presentation/view_model/cubit/join_team_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/repositories/implement_join_team_repo.dart';
import 'package:get/get.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cubit = context.read<ChangeBtnNavBarCubit>();
        if (notification.type == 'taskPosted') {
          //view task in team leader ui
          Get.toNamed(AppRoutes.taskDetailsForTeam,
              arguments: notification.data);
          context.read<NotificationsCubit>().markAsRead(notification.id!);
        } else if (notification.type == 'taskRequest') {
          Get.toNamed(AppRoutes.viewProposalDetails,
              arguments: notification.data);
          context.read<NotificationsCubit>().markAsRead(notification.id!);
        } else if (notification.type == 'taskAccepted') {
          cubit.changeCurrentIndex(3);
          context.read<NotificationsCubit>().markAsRead(notification.id!);
        } else if (notification.type == 'joinTeam') {
          if (notification.data != null) {
            _showJoinTeamDialog(context, notification.data!);
          }
          context.read<NotificationsCubit>().markAsRead(notification.id!);
        }
      },
      child: NotificationItemBody(notification: notification),
    );
  }

  void _showJoinTeamDialog(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) =>
              JoinTeamCubit(joinTeamRepo: JoinTeamRepoImplementation())
                ..getSpecificJoinRequest(requestId),
          child: JoinTeamDialog(requestId: requestId),
        );
      },
    );
  }
}
