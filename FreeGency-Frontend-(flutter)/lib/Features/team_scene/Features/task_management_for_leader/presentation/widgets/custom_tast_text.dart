import 'package:flutter/material.dart';

class CustomContainerText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;

  const CustomContainerText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w300,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: fontWeight,
      ),
    );
  }
}
