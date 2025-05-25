import 'package:flutter/material.dart';
import 'package:tutor/features/home/widgets/home_filter_section_widget.dart';
import 'package:tutor/features/home/widgets/home_chip_widget.dart';

class HomeFilterBottomSheetWidget extends StatelessWidget {
  final bool isTeacherMode;
  final String selectedOrderBy;
  final double currentPriceFilter;
  final double maxPrice;
  final List<String> orderByOptions;
  final Function(bool) onModeChanged;
  final Function(String) onOrderByChanged;
  final Function(double) onPriceFilterChanged;
  final VoidCallback onPriceFilterApplied;
  final VoidCallback onClearFilters;

  const HomeFilterBottomSheetWidget({
    super.key,
    required this.isTeacherMode,
    required this.selectedOrderBy,
    required this.currentPriceFilter,
    required this.maxPrice,
    required this.orderByOptions,
    required this.onModeChanged,
    required this.onOrderByChanged,
    required this.onPriceFilterChanged,
    required this.onPriceFilterApplied,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.8,
      minChildSize: 0.4,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  HomeFilterSectionWidget(
                    title: 'Display Mode',
                    content: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Courses'),
                          leading: Radio<bool>(
                            value: false,
                            groupValue: isTeacherMode,
                            onChanged: (value) {
                              onModeChanged(false);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Teachers'),
                          leading: Radio<bool>(
                            value: true,
                            groupValue: isTeacherMode,
                            onChanged: (value) {
                              onModeChanged(true);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  HomeFilterSectionWidget(
                    title: 'Sort By',
                    content: Wrap(
                      spacing: 8,
                      children: orderByOptions.map((option) => HomeChipWidget(
                        label: option,
                        isSelected: selectedOrderBy == option,
                        onTap: () => onOrderByChanged(option),
                      )).toList(),
                    ),
                  ),
                  if (!isTeacherMode) ...[
                    HomeFilterSectionWidget(
                      title: 'Price Range',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Up to ${currentPriceFilter.toInt()} VND'),
                          Slider(
                            value: currentPriceFilter,
                            min: 0,
                            max: maxPrice,
                            divisions: 10,
                            onChanged: onPriceFilterChanged,
                            onChangeEnd: (value) => onPriceFilterApplied(),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onClearFilters,
                          child: const Text('Clear All'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}