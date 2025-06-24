import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // لازم عشان النسخ
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class TeamCodeInputField extends StatelessWidget {
  const TeamCodeInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Icon(
            Iconsax.key,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: BlocBuilder<ValidationCubit, ValidationState>(
            builder: (context, state) {
              return TextField(
                controller: context.read<ValidationCubit>().teamCodeController,
                readOnly: true,
                enableInteractiveSelection: true,
                style: AppTextStyles.poppins14Regular(context)!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Team Code',
                  hintStyle: AppTextStyles.poppins14Regular(context),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Iconsax.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: context
                              .read<ValidationCubit>()
                              .teamCodeController
                              .text));
                      showAppSnackBar(
                        context,
                        message: 'Team code copied!',
                        type: SnackBarType.success,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
