import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/presentation/view_model/available_jobs_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/presentation/widgets/available_jobs_card.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class AvailableJobsCardsBuilder extends StatefulWidget {
  const AvailableJobsCardsBuilder({
    super.key,
    required this.scrollController,
    this.categoryId,
  });

  final ScrollController scrollController;
  final String? categoryId;

  @override
  State<AvailableJobsCardsBuilder> createState() =>
      _AvailableJobsCardsBuilderState();
}

class _AvailableJobsCardsBuilderState extends State<AvailableJobsCardsBuilder> {
  @override
  void initState() {
    super.initState();
    // The tab controller will handle fetching data
    // No need to fetch here to avoid duplicate calls
  }

  @override
  void didUpdateWidget(AvailableJobsCardsBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Tab controller will handle data fetching
    // No need to fetch here to avoid duplicate calls
    if (oldWidget.categoryId != widget.categoryId) {
      log('🔄 CategoryId changed from ${oldWidget.categoryId} to ${widget.categoryId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailableJobsCubit, AvailableJobsState>(
      builder: (context, state) {
        if (state is AvailableJobsLoading) {
          return const Center(child: AppLoadingIndicator());
        } else if (state is AvailableJobsSuccess) {
          if (state.jobs.isEmpty) {
            return const Center(
              child: Text(
                'No jobs available',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            controller: widget.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (BuildContext context, int index) {
              return AvailableJobsCard(
                job: state.jobs[index],
              );
            },
            separatorBuilder: (context, index) => 16.height,
            itemCount: state.jobs.length,
          );
        } else if (state is AvailableJobsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.errorMessage}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      context
                          .read<AvailableJobsCubit>()
                          .getAvailableJobs(categoryId: widget.categoryId);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
