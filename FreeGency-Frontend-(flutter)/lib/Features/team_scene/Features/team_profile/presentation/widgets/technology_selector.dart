import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/utils/constants/technologies_list.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class TechnologySelector extends StatefulWidget {
  final List<String> selectedTechnologies;
  final Function(String) onTechnologyAdded;
  final Function(String) onTechnologyRemoved;

  const TechnologySelector({
    super.key,
    required this.selectedTechnologies,
    required this.onTechnologyAdded,
    required this.onTechnologyRemoved,
  });

  @override
  State<TechnologySelector> createState() => _TechnologySelectorState();
}

class _TechnologySelectorState extends State<TechnologySelector> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.h.height,
        CustomDropdown<String>.search(
          decoration: CustomDropdownDecoration(
            listItemStyle: AppTextStyles.poppins16Regular(context),
            searchFieldDecoration: SearchFieldDecoration(
              hintStyle: AppTextStyles.poppins14Regular(context),
              textStyle: AppTextStyles.poppins16Regular(context),
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            closedSuffixIcon: const SizedBox(),
            expandedSuffixIcon: const SizedBox(),
            expandedFillColor: Theme.of(context).colorScheme.primaryContainer,
            closedFillColor: Theme.of(context).colorScheme.primaryContainer,
            hintStyle: AppTextStyles.poppins14Regular(context),
            headerStyle: AppTextStyles.poppins14Regular(context)!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          hintText: 'Search and select technologies...',
          items: technologiesList
              .where((tech) => !widget.selectedTechnologies.contains(tech))
              .toList(),
          onChanged: (selectedItem) {
            if (selectedItem != null &&
                !widget.selectedTechnologies.contains(selectedItem)) {
              widget.onTechnologyAdded(selectedItem);
              searchController.clear();
            }
          },
          overlayHeight: 500.h,
        ),
        8.h.height,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: widget.selectedTechnologies.map((technology) {
            return Chip(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.20),
              avatar: null,
              labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
                side: const BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              label: Text(
                technology,
                style: AppTextStyles.poppins12Regular(context)!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              deleteIcon: Icon(
                Icons.close,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              onDeleted: () {
                widget.onTechnologyRemoved(technology);
              },
            );
          }).toList(),
        ),
        8.h.height,
      ],
    );
  }
}
