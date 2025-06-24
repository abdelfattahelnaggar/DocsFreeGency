import 'package:flutter/material.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class DateInputTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const DateInputTextField({
    super.key,
    required this.controller,
    this.hintText = 'YYYY/MM/DD',
  });

  @override
  DateInputTextFieldState createState() => DateInputTextFieldState();
}

class DateInputTextFieldState extends State<DateInputTextField> {
  DateTime _selectedDate = DateTime.now();

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: 350,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ScrollDatePicker(
                      selectedDate: _selectedDate,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          _selectedDate = newDate;
                        });
                      },
                      maximumDate: DateTime(DateTime.now().year + 5),
                      minimumDate: DateTime.now(),
                      options: DatePickerOptions(
                        isLoop: false,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                  // Save Button
                  PrimaryCTAButton(
                    label: 'Save',
                    onTap: () {
                      Navigator.pop(context, _selectedDate);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
      setState(() {
        widget.controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      style: AppTextStyles.poppins16Regular(context),
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.primaryContainer,
        filled: true,
        hintText: widget.hintText,
        hintStyle: AppTextStyles.poppins14Regular(context),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.calendar_today,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => _selectDate(context),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
