import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tutor/features/home/widgets/home_filter_section_widget.dart';
import 'package:tutor/features/home/widgets/home_chip_widget.dart';

class HomeFilterBottomSheetWidget extends StatefulWidget {
  final bool isTeacherMode;
  final String selectedOrderBy;
  final double currentPriceFilter;
  final double maxPrice;
  final int maxExperience;
  final int currentExperienceFilter;
  final List<String> orderByOptions;
  final Function(String) onOrderByChanged;
  final Function(double) onPriceFilterChanged;
  final Function(int) onExperienceFilterChanged;
  final VoidCallback onApplyFilters;
  final VoidCallback onClearFilters;

  const HomeFilterBottomSheetWidget({
    super.key,
    required this.isTeacherMode,
    required this.selectedOrderBy,
    required this.currentPriceFilter,
    required this.maxPrice,
    required this.maxExperience,
    required this.currentExperienceFilter,
    required this.orderByOptions,
    required this.onOrderByChanged,
    required this.onPriceFilterChanged,
    required this.onExperienceFilterChanged,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  _HomeFilterBottomSheetWidgetState createState() => _HomeFilterBottomSheetWidgetState();
}

class _HomeFilterBottomSheetWidgetState extends State<HomeFilterBottomSheetWidget> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _debounceSetState(VoidCallback callback) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), callback);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                HomeFilterSectionWidget(
                  title: 'Sort By',
                  content: Wrap(
                    spacing: 8,
                    children: widget.orderByOptions.map((option) => HomeChipWidget(
                      label: option,
                      isSelected: widget.selectedOrderBy == option,
                      onTap: () => widget.onOrderByChanged(option),
                    )).toList(),
                  ),
                ),
                if (!widget.isTeacherMode) ...[
                  HomeFilterSectionWidget(
                    title: 'Price Range',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Up to ${widget.currentPriceFilter.toInt()} VND',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10), // Larger thumb
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
                          ),
                          child: Slider(
                            value: widget.currentPriceFilter,
                            min: 0,
                            max: widget.maxPrice,
                            divisions: 50,
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey[300],
                            label: widget.currentPriceFilter.round().toString(),
                            onChanged: (value) {
                              _debounceSetState(() {
                                widget.onPriceFilterChanged(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (widget.isTeacherMode) ...[
                  HomeFilterSectionWidget(
                    title: 'Experience Range',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Up to ${widget.currentExperienceFilter} years',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
                          ),
                          child: Slider(
                            value: widget.currentExperienceFilter.toDouble(),
                            min: 0,
                            max: widget.maxExperience.toDouble(),
                            divisions: widget.maxExperience,
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey[300],
                            label: widget.currentExperienceFilter.toString(),
                            onChanged: (value) {
                              _debounceSetState(() {
                                widget.onExperienceFilterChanged(value.toInt());
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onClearFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onApplyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}