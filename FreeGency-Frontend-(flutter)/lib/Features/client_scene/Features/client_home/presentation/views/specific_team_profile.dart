import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/client_home_repository/implemented_client_home_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/specific_team_functionality/cubit/specific_team_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/specific_team_details_body.dart';

class SpecificTeamProfileScreen extends StatelessWidget {
  const SpecificTeamProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final team = ModalRoute.of(context)?.settings.arguments as TeamsModel;
    return BlocProvider(
      create: (context) =>
          SpecificTeamFunctionalityCubit(ImplementedClientHomeRepo())
            ..getSpecificTeam(team.id ?? ''),
      child: const SpecificTeamProfileBody(),
    );
  }
}
