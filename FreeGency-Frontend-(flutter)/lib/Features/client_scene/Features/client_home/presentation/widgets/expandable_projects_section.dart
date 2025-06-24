import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/specific_team_functionality/cubit/specific_team_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/grid_view_loaded.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/grid_view_loading.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class ExpandableProjectsSection extends StatefulWidget {
  final TeamsModel team;
  final SpecificTeamFunctionalityState state;
  
  const ExpandableProjectsSection({
    super.key,
    required this.team,
    required this.state,
  });

  @override
  State<ExpandableProjectsSection> createState() => _ExpandableProjectsSectionState();
}

class _ExpandableProjectsSectionState extends State<ExpandableProjectsSection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Projects header with expand/collapse button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('projects'),
              style: AppTextStyles.poppins16Bold(context),
            ),
            IconButton(
              onPressed: _toggleExpanded,
              icon: AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Iconsax.arrow_down_1),
              ),
            ),
          ],
        ),
        
        // Expandable content
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Column(
            children: [
              SizedBox(height: 16.h),
              
              if (widget.state is SpecificTeamFunctionalityLoading)
                const GridViewLoading()
              // Project cards
              else if (widget.team.projects != null &&
                  widget.team.projects!.isNotEmpty)
                GridViewLoaded(team: widget.team)
              // No projects message
              else
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: Text(
                      context.tr('no_projects_available'),
                      style: AppTextStyles.poppins14Regular(context),
                    ),
                  ),
                ),
              
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }
} 