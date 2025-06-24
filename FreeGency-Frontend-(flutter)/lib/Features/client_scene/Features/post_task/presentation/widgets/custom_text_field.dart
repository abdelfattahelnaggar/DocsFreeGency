import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int? maxLength;
  final int? maxLines;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Color? fillColor;
  final bool isPassword;

  const CustomTextField(
      {super.key,
      required this.hintText,
      this.maxLength,
      this.maxLines,
      this.onChanged,
      required this.controller,
      this.textInputType,
      this.prefixIcon,
      this.validator,
      this.readOnly = false,
      this.fillColor,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      readOnly: readOnly,
      obscureText: isPassword,
      style: AppTextStyles.poppins16Regular(context),
      decoration: InputDecoration(
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon,
                size: 20, color: Theme.of(context).colorScheme.secondary),
        fillColor: fillColor ?? Theme.of(context).colorScheme.primaryContainer,
        filled: true,
        hintText: hintText,
        hintStyle: AppTextStyles.poppins14Regular(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(12),
        //   borderSide: BorderSide(
        //       color: Theme.of(context).colorScheme.primary, width: 2),
        // ),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
