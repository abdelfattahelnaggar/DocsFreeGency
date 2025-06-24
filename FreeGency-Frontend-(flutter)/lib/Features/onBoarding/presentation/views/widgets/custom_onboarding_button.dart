import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/view_model/cubit/change_scene_cubit/change_scene_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class CustomOnBoardingButton extends StatelessWidget {
  const CustomOnBoardingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChangeSceneCubit>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: cubit.goToNextPage,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          textStyle: const TextStyle(
            fontSize: 14,
          ),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          fixedSize: const Size(250, 60),
        ),
        child: BlocBuilder<ChangeSceneCubit, ChangeSceneState>(
          builder: (context, state) {
            return Text(
              cubit.buttonText(),
              style: AppTextStyles.poppins14Regular(context)!.copyWith(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
