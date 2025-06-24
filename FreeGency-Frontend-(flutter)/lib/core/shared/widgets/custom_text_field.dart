import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

enum TextFieldValidation {
  NONE, // No validation
  EMAIL, // Email validation
  PASSWORD, // Password validation
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.controller,
    this.prefixIcon = Iconsax.sms,
    this.validationType = TextFieldValidation.NONE,
    this.onChanged,
  });

  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final IconData prefixIcon;
  final TextFieldValidation validationType;
  final Function(String)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ValidationCubit>();
    return TextFormField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      autofillHints: const [AutofillHints.email],
      keyboardType: widget.isPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      obscureText: widget.isPassword ? _obscureText : false,
      style: AppTextStyles.poppins16Regular(context),
      decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          filled: true,
          hintText: widget.label,
          hintStyle: AppTextStyles.poppins14Regular(context),
          prefixIcon: Icon(
            widget.isPassword ? Iconsax.lock : widget.prefixIcon,
            size: 18,
            color: Theme.of(context).colorScheme.secondary,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Iconsax.eye_slash : Iconsax.eye,
                    color: !_obscureText
                        ? Colors.green
                        : Theme.of(context).colorScheme.secondary,
                    size: 18,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          errorStyle: AppTextStyles.poppins12Regular(context)!.copyWith(
            color: Theme.of(context).colorScheme.error,
          )),
      validator: (value) => cubit.validator(value, widget.validationType),
    );
  }
}
