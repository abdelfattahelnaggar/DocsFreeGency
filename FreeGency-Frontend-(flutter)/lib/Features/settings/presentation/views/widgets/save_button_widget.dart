import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/user_profile_cubit.dart';
import '../../cubit/user_profile_state.dart';

class SaveButtonWidget extends StatelessWidget {
  final VoidCallback onSave;

  const SaveButtonWidget({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileUpdating) {
              return const ElevatedButton(
                onPressed: null,
                child: CircularProgressIndicator(),
              );
            }
            return ElevatedButton(
              onPressed: onSave,
              child: Text(context.tr('save_changes')),
            );
          },
        ),
      ),
    );
  }
}
