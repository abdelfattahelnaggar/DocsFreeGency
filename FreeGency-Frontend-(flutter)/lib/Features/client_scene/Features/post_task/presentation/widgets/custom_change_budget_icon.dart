import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomChangeBudgetIcon extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  const CustomChangeBudgetIcon({super.key , required this.onTap , required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 4.h,
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
