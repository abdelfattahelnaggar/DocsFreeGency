import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Shimmer.fromColors(
        period: const Duration(
            milliseconds:
                1500), // Slightly slower animation to reduce CPU usage
        baseColor: baseColor ?? theme.colorScheme.secondary.withValues(alpha:0.3),
        highlightColor:
            highlightColor ?? theme.colorScheme.secondary.withValues(alpha:0.1),
        child: child,
      ),
    );
  }
}
