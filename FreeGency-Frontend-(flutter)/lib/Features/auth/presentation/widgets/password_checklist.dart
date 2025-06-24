import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class PasswordChecklist extends StatelessWidget {
  const PasswordChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationState>(
      builder: (context, state) {
        if (state is! PasswordChecklistUpdated) {
          return const SizedBox.shrink();
        }

        final checklist = state.checklist;
        final unmetRequirements =
            checklist.entries.where((entry) => !entry.value).toList();

        if (unmetRequirements.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: unmetRequirements.map((entry) {
            String text;
            switch (entry.key) {
              case PasswordRequirement.EIGHT_CHARS:
                text = context.tr('password_req_length');
                break;
              case PasswordRequirement.UPPERCASE:
                text = context.tr('password_req_uppercase');
                break;
              case PasswordRequirement.LOWERCASE:
                text = context.tr('password_req_lowercase');
                break;
              case PasswordRequirement.DIGIT:
                text = context.tr('password_req_digit');
                break;
              case PasswordRequirement.SPECIAL_CHAR:
                text = context.tr('password_req_special');
                break;
            }
            return _buildChecklistItem(context, text);
          }).toList(),
        );
      },
    );
  }

  Widget _buildChecklistItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Iconsax.close_circle,
            color: Theme.of(context).colorScheme.error,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.poppins14Regular(context),
          ),
        ],
      ),
    );
  }
}
