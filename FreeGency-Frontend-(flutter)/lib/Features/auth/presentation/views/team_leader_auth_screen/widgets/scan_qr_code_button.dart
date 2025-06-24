import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScanQRCode extends StatelessWidget {
  const ScanQRCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SvgPicture.asset(
        'assets/icons/scan.svg',
        colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary, BlendMode.srcIn),
      ),
    );
  }
}
