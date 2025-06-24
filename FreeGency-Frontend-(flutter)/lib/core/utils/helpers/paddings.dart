import 'package:flutter/material.dart';

extension EdgeInsetsExtensions on num {
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());

  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets paddingOnly({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      top: top ?? toDouble(),
      bottom: bottom ?? toDouble(),
      left: left ?? toDouble(),
      right: right ?? toDouble(),
    );
  }
}
