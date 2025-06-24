import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/view_model/cubit/change_scene_cubit/change_scene_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/keep_alive_page.dart';

class ImagePageView extends StatelessWidget {
  const ImagePageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChangeSceneCubit>();
    return Expanded(
      child: KeepAlivePageView(
        controller: cubit.pageController,
        onPageChanged: (index) {
          cubit.updateCurrentIndex(index);
        },
        children: List.generate(
          4,
          (index) => Image.asset('assets/images/onBoarding${index + 1}.png'),
        ),
      ),
    );
  }
}
