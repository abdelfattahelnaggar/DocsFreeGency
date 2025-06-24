import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/views/team_profile_screen.dart';

// This file is now just a wrapper that delegates to the modularized implementation
class MyTeamProfileScreen extends StatelessWidget {
  const MyTeamProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TeamProfileScreen();
  }
}
