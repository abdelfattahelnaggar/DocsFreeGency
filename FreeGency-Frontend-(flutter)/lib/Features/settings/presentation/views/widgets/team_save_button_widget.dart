import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/team_profile_cubit.dart';
import '../../cubit/team_profile_state.dart';

class TeamSaveButtonWidget extends StatelessWidget {
  final VoidCallback onSave;

  const TeamSaveButtonWidget({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<TeamProfileCubit, TeamProfileState>(
        builder: (context, state) {
          if (state is TeamProfileUpdating) {
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
    );
  }
}
