import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/onBoarding/presentation/view_model/cubit/change_scene_cubit/change_scene_cubit.dart';

class SwappingDots extends StatelessWidget {
  const SwappingDots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChangeSceneCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: List.generate(
        4,
        (index) => BlocBuilder<ChangeSceneCubit, ChangeSceneState>(
          builder: (context, state) {
            return AnimatedContainer(
              width: 10,
              height: cubit.currentIndex != index ? 10 : 24,
              duration: const Duration(milliseconds: 800),
              decoration: BoxDecoration(
                color: cubit.currentIndex != index
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(100),
              ),
            );
          },
        ),
      ),
    );
  }
}
