import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class SelectedTextDisplay extends StatelessWidget {
  final String categoryID;

  const SelectedTextDisplay({
    super.key,
    required this.categoryID,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ReusableTextStyleMethods.poppins24BoldMethod(
            context: context,
            text: categoryID,
          ),
          8.height,
        ],
      ),
    );
  }
}
