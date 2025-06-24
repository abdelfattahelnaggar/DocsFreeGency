import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';

class TeamAvatarsWidget extends StatelessWidget {
  final TaskModel task;

  const TeamAvatarsWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Use assigned members from task or fallback to placeholder
    final List<String> imageUrls =
        task.assignedMembers?.map((e) => e.profileImage ?? '').toList() ?? [];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(
        imageUrls.length,
        (index) {
          return Transform.translate(
            offset: Offset(index * -10.0, 0),
            child: imageUrls.isNotEmpty
                ? CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                      imageUrls[index],
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
