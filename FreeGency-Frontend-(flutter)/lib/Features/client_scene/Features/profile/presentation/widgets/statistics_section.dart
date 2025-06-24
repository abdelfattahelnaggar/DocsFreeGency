import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/statistic_item.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatisticItem(
          image: 'chart',
          label: 'Posted\nProjects',
          value: '30',
        ),
        StatisticItem(
          image: 'timer',
          label: 'Projects\ninProgress',
          value: '4',
        ),
        StatisticItem(
          image: 'like',
          label: 'Completed\nProjects',
          value: '16',
        ),
      ],
    );
  }
}
