import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class HeaderSection extends StatelessWidget {
  final VoidCallback onSkipPressed;

  const HeaderSection({
    super.key,
    required this.onSkipPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: onSkipPressed,
                child: ReusableTextStyleMethods.poppins12RegularMethod(
                  context: context,
                  text: "Skip",
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableTextStyleMethods.poppins16BoldMethod(
                    context: context,
                    text: 'Select Your Interests',
                  ),
                  16.height,
                  ReusableTextStyleMethods.poppins14RegularMethod(
                    context: context,
                    text:
                        'Choose the fields that match your project needs or your preferred job search categories.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
