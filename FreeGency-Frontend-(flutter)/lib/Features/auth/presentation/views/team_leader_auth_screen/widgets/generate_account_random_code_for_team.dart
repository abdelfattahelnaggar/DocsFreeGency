import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class GenerateRandomCodeRow extends StatelessWidget {
  const GenerateRandomCodeRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        const Icon(
          Iconsax.magicpen,
          color: Color(0xff5482FF),
          size: 24,
        ),
        TextButton(
          onPressed: () {
            const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
            final rand = Random();
            final randomCode =
                List.generate(16, (index) => chars[rand.nextInt(chars.length)])
                    .join();

            final cubit = context.read<ValidationCubit>();
            cubit.teamCodeController.text = randomCode;
          },
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
            minimumSize: WidgetStateProperty.all<Size>(Size.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Generate random code?',
            style: AppTextStyles.poppins12Regular(context)!.copyWith(
              color: const Color(0xff5482FF),
            ),
          ),
        ),
      ],
    );
  }
}
