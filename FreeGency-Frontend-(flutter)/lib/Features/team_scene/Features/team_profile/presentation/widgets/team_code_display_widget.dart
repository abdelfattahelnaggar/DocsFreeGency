import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/view_model/cubit/team_profile_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';

class TeamCodeDisplayWidget extends StatelessWidget {
  const TeamCodeDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamProfileCubit, TeamProfileState>(
      builder: (context, state) {
        final cubit = context.read<TeamProfileCubit>();
        // Get team code from model or generate a placeholder
        final teamCode = cubit.myTeam?.teamCode ?? 'TEAM-123456';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            ReusableTextStyleMethods.poppins16BoldMethod(
                context: context, text: 'Team Code'),
            12.height,
            // Team Code Field styled like the registration page
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Row(
                children: [
                  // Left icon container
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        bottomLeft: Radius.circular(12.r),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Icon(
                      Iconsax.key,
                      color: Colors.white,
                    ),
                  ),
                  // Text field part
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: teamCode),
                      readOnly: true,
                      enableInteractiveSelection: true,
                      style: AppTextStyles.poppins14Regular(context)!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Team Code',
                        hintStyle: AppTextStyles.poppins14Regular(context),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Copy button
                            IconButton(
                              icon: const Icon(Iconsax.copy),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: teamCode));
                                showAppSnackBar(
                                  context,
                                  message: 'Team code copied!',
                                  type: SnackBarType.success,
                                );
                              },
                            ),
                            // Share button
                            IconButton(
                              icon: const Icon(Iconsax.share),
                              onPressed: () {
                                Share.share(
                                  'Join our team with code: $teamCode',
                                  subject: 'Team Invitation',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            16.height,
          ],
        );
      },
    );
  }
}
