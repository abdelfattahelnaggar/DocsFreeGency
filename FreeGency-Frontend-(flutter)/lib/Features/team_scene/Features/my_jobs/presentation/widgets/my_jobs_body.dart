import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/presentation/view_model/cubits/my_jobs_cubit/my_jobs_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/presentation/view_model/cubits/my_jobs_cubit/my_jobs_state.dart';
import 'package:freegency_gp/Features/team_scene/Features/my_jobs/presentation/widgets/my_jobs_available_card.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class MyJobsBody extends StatefulWidget {
  const MyJobsBody({
    super.key,
  });

  @override
  State<MyJobsBody> createState() => _MyJobsBodyState();
}

class _MyJobsBodyState extends State<MyJobsBody> {
  late MyJobsCubit myJobsCubit;

  @override
  void initState() {
    super.initState();
    myJobsCubit = context.read<MyJobsCubit>();
    // Load jobs when the widget initializes
    myJobsCubit.getMyJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocListener<MyJobsCubit, MyJobsState>(
                listener: (context, state) {
                  if (state is DeleteJobSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Job deleted successfully',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else if (state is DeleteJobError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error deleting job: ${state.errorMessage}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: RefreshIndicator(
                  onRefresh: () => myJobsCubit.refreshJobs(),
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: BlocBuilder<MyJobsCubit, MyJobsState>(
                    builder: (context, state) {
                      if (state is MyJobsLoading || state is DeleteJobLoading) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      } else if (state is MyJobsError) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 64.sp,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Error: ${state.errorMessage}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 16.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.h),
                                  ElevatedButton(
                                    onPressed: () => myJobsCubit.getMyJobs(),
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (state is MyJobsSuccess) {
                        final jobs = state.jobs;
                        if (jobs.isEmpty) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.work_outline,
                                      size: 64.sp,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'No jobs found',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Create your first job posting to get started',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 14.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            return MyJobsAvailableCard(
                              job: job,
                              onTap: () {
                                // TODO: Implement job details
                                // Navigate to job details screen
                              },
                            );
                          },
                          separatorBuilder: (context, index) => 16.height,
                        );
                      } else {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Text(
                                'Welcome to My Jobs',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
