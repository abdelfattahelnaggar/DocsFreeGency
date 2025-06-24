import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/budget_input.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';

class BudgetSection extends StatefulWidget {
  final bool isFixedPrice;
  final TextEditingController budgetController;
  final Function(bool) onPriceTypeChanged;

  const BudgetSection({
    super.key,
    required this.isFixedPrice,
    required this.budgetController,
    required this.onPriceTypeChanged,
  });

  @override
  State<BudgetSection> createState() => _BudgetSectionState();
}

class _BudgetSectionState extends State<BudgetSection> {
  late bool _isFixedPrice;

  @override
  void initState() {
    super.initState();
    _isFixedPrice = widget.isFixedPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableTextStyleMethods.poppins16RegularMethod(
              context: context,
              text: 'Budget (USD)',
            ),
            Row(
              children: [
                Checkbox(
                  value: _isFixedPrice,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isFixedPrice = newValue ?? false;
                      widget.onPriceTypeChanged(_isFixedPrice);
                    });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                ReusableTextStyleMethods.poppins14RegularMethod(
                  context: context,
                  text: 'Fixed Price',
                ),
              ],
            ),
          ],
        ),

        // Budget Field
        BudgetInputWidget(
          budgetController: widget.budgetController,
          onBudgetChanged: (budget) {
            log('Budget changed to: $budget');
          },
        ),
      ],
    );
  }
}
