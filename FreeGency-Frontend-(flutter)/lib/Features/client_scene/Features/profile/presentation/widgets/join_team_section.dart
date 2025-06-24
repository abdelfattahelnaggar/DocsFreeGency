import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/presentation/views/join_team_screen.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class JoinTeamSection extends StatelessWidget {
  const JoinTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const JoinTeamScreen(),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.magicpen, color: Colors.blue),
          4.w.width,
          Text(
            "Join to team",
            style: AppTextStyles.poppins16Regular(context)!.copyWith(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
