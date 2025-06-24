import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 50,
    this.color,
    this.center = true,
  });

  final double size;
  final Color? color;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final Widget loadingWidget = LoadingAnimationWidget.staggeredDotsWave(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size,
    );

    if (center) {
      return Center(child: loadingWidget);
    }
    return loadingWidget;
  }
}
