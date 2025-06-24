import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/view_models/cubits/post_task_from_client_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class UploadRelatedFiles extends StatelessWidget {
  const UploadRelatedFiles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostTaskFromClientCubit, PostTaskFromClientState>(
      builder: (context, state) {
        final cubit = context.read<PostTaskFromClientCubit>();
        final file = cubit.pickedFile;

        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.01),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            children: [
              if (file != null)
                Column(
                  children: [
                    if (file.path.toLowerCase().endsWith('.jpg') ||
                        file.path.toLowerCase().endsWith('.jpeg') ||
                        file.path.toLowerCase().endsWith('.png'))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(
                          file,
                          height: 150.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: 150.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.insert_drive_file,
                              size: 48.r,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            8.h.height,
                            Text(
                              file.path.split('/').last,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    16.h.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          file.path.split('/').last,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        IconButton(
                          onPressed: () => cubit.clearFile(),
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                SvgPicture.asset(
                  'assets/images/Pick a file.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
              if (file == null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: PrimaryCTAButton(
                    label: 'Upload Related Files',
                    onTap: cubit.chooseFileFromDevice,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
