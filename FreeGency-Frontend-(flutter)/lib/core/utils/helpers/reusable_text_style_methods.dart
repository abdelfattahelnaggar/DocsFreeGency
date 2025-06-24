import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class ReusableTextStyleMethods {
  static Widget poppins20BoldMethod({
    required BuildContext context,
    required String text,
  }) {
    return Text(
      text,
      style: AppTextStyles.poppins20Bold(context),
    );
  }

  static Widget poppins24BoldMethod({
    required BuildContext context,
    required String text,
    // int maxline = 1
  }) {
    return Text(
      text,
      style: AppTextStyles.poppins24Bold(context),
    );
  }

  static Widget poppins14RegularMethod({
    required BuildContext context,
    required String text,
  }) {
    return Text(
      text,
      style: AppTextStyles.poppins14Regular(context),
    );
  }

  static Widget poppins14BoldMethod({
    required BuildContext context,
    required String text,
    // int maxline = 1,
  }) {
    return Text(
      text,
      style: AppTextStyles.poppins14Regular(context)!.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  static Widget poppins16RegularMethod({
    required BuildContext context,
    required String text,
  }) {
    return Text(
      text,
      style: AppTextStyles.poppins16Regular(context),
    );
  }

  static Widget poppins16BoldMethod({
    required BuildContext context,
    required String text,
  }) {
    return Text(
      text,
      style: AppTextStyles.poppins16Bold(context),
    );
  }

  static Widget poppins12RegularMethod({
    required BuildContext context,
    required String text,
  }) {
    return Text(
      text,
      style: AppTextStyles.poppins12Regular(context),
    );
  }
}
