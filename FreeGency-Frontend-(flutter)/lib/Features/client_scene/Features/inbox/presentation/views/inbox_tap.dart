import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/view_model/cubit/notifications_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/widgets/filter_header.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/widgets/notifications_body.dart';

class InboxTap extends StatefulWidget {
  const InboxTap({super.key});

  @override
  State<InboxTap> createState() => _InboxTapState();
}

class _InboxTapState extends State<InboxTap> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NotificationsCubit>().fetchNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<NotificationsCubit, NotificationsState>(
          buildWhen: (prev, current) => current is NotificationsFilterChanged,
          builder: (context, state) {
            return FilterHeader(
              cubit: context.read<NotificationsCubit>(),
            );
          },
        ),
        const Expanded(child: NotificationsListView()),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}