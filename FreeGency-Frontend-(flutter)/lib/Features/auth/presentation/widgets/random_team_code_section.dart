import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/scan_qr_code_button.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/team_code_input_field.dart';

class RandomCodeInputSection extends StatelessWidget {
  const RandomCodeInputSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: const TeamCodeInputField(),
          ),
        ),
        const ScanQRCode()
      ],
    );
  }
}
