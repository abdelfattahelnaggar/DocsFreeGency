import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/repositories/implement_team_leader_auth_repo.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/teamLeader_auth_cubit/team_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/team_leader_login_body.dart';

class TeamLeaderLoginScreen extends StatelessWidget {
  const TeamLeaderLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ValidationCubit(),
            ),
            BlocProvider(
              create: (context) =>
                  TeamAuthCubit(TeamLeaderAuthRepoImplementation()),
            ),
          ],
          child: const TeamLeaderLoginScreenBody(),
        ),
      ),
    );
  }
}
