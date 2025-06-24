import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/onBoarding/data/models/description_model.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/view_model/cubit/change_scene_cubit/change_scene_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChangeSceneCubit>();

    // Use localized texts
    List<DescriptionModel> onBoardingTexts =
        DescriptionModel.getLocalizedTexts(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 32),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(),
      child: BlocBuilder<ChangeSceneCubit, ChangeSceneState>(
        builder: (context, state) {
          return Column(
            children: [
              ReusableTextStyleMethods.poppins20BoldMethod(
                  context: context,
                  text: onBoardingTexts[cubit.currentIndex].title),
              8.height,
              Text(
                onBoardingTexts[cubit.currentIndex].subTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.poppins14Regular(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
