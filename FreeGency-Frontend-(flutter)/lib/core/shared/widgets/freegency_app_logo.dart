import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freegency_gp/core/utils/constants/assets.dart';

class FreeGencyLogo extends StatelessWidget {
  const FreeGencyLogo({
    super.key,
    this.color,
    this.width,
  });

  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) { 
    return SvgPicture.asset( 
      width: width ?? 210,
      AppAssets.appLogo,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : ColorFilter.mode(
              Theme.of(context).colorScheme.primary, BlendMode.srcIn),
      theme: SvgTheme(
        currentColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
