import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PositionedSVG extends StatelessWidget {
  const PositionedSVG({
    super.key,
    required this.path,
    required this.x,
    required this.y,
  });

  final String path;
  final double x, y;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: SvgPicture.asset(
        path,
        theme: SvgTheme(currentColor: Theme.of(context).colorScheme.surface),
      ),
    );
  }
}
