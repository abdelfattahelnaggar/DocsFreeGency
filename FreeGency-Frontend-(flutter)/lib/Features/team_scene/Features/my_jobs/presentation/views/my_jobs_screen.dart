import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/presentation/view_model/cubits/my_jobs_cubit/my_jobs_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/presentation/widgets/my_jobs_body.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyJobsCubit(),
      child: const MyJobsBody(),
    );
  }
}
