
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/tag_item.dart';

class WrapSkills extends StatelessWidget {
  const WrapSkills({
    super.key,
    required this.team,
  });

  final TeamsModel team;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        if (team.skills != null && team.skills!.isNotEmpty)
          ...team.skills!.map((skill) => SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: TagItem(tag: skill),
                  ),
                ),
              ))
        else
          const SizedBox.shrink(),
      ],
    );
  }
}