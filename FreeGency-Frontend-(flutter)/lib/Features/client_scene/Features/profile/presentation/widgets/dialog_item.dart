import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/user_data_functionality_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:freegency_gp/core/utils/services/camera_services.dart';

class DialogItem extends StatelessWidget {
  const DialogItem({
    super.key,
    required this.cubit,
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
  final UserDataFunctionalityCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () async {
            try {
              Navigator.of(context).pop();

              final image = text == 'Camera'
                  ? await CameraService.cameraPicker()
                  : await CameraService.galleryPicker();

              if (image != null) {
                await cubit.uploadImage(image);
              }
            } catch (e) {
              if (context.mounted) {
                showAppSnackBar(
                  context,
                  message: 'فشل تحميل الصورة: ${e.toString()}',
                  type: SnackBarType.error,
                );
              }
            }
          },
          icon: Icon(
            icon,
            size: 40.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          text,
          style: AppTextStyles.poppins14Regular(context)
              ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        )
      ],
    );
  }
}
