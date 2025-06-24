import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_change_budget_icon.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';

class BudgetInputWidget extends StatefulWidget {
  final ValueChanged<double>? onBudgetChanged;
  final TextEditingController budgetController;

  const BudgetInputWidget(
      {super.key, this.onBudgetChanged, required this.budgetController});

  @override
  BudgetInputWidgetState createState() => BudgetInputWidgetState();
}

class BudgetInputWidgetState extends State<BudgetInputWidget> {
  @override
  void initState() {
    super.initState();
  }

  void _incrementBudget() {
    double currentValue = double.tryParse(widget.budgetController.text) ?? 0;
    setState(() {
      currentValue += 50;
      widget.budgetController.text = currentValue.toStringAsFixed(0);
      widget.onBudgetChanged?.call(currentValue);
    });
  }

  void _decrementBudget() {
    double currentValue = double.tryParse(widget.budgetController.text) ?? 0;
    setState(() {
      currentValue = (currentValue - 50).clamp(0, double.infinity);
      widget.budgetController.text = currentValue.toStringAsFixed(0);
      widget.onBudgetChanged?.call(currentValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: widget.budgetController,
            hintText: 'Example : 150 \$',
            textInputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Budget is required';
              }
              final budget = double.tryParse(value);
              if (budget == null || budget <= 0) {
                return 'Budget must be a positive number';
              }
              return null;
            },
            onChanged: (value) {
              widget.onBudgetChanged?.call(double.tryParse(value) ?? 0);
            },
          ),
        ),
        Column(
          children: [
            CustomChangeBudgetIcon(
              onTap: _incrementBudget,
              icon: Icons.arrow_drop_up,
            ),
            CustomChangeBudgetIcon(
              onTap: _decrementBudget,
              icon: Icons.arrow_drop_down,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
