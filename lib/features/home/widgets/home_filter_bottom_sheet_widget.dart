import 'package:flutter/material.dart';
import 'package:tutor/features/home/widgets/home_filter_section_widget.dart';
import 'package:tutor/features/home/widgets/home_chip_widget.dart';

class HomeFilterBottomSheetWidget extends StatefulWidget {
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
  _HomeFilterBottomSheetWidgetState createState() => _HomeFilterBottomSheetWidgetState();
}

class _HomeFilterBottomSheetWidgetState extends State<HomeFilterBottomSheetWidget> with SingleTickerProviderStateMixin {
  bool _isClearPressed = false;
  bool _isApplyPressed = false;

  void _onClearTapDown(TapDownDetails details) {
    setState(() {
      _isClearPressed = true;
    });
  }

  void _onClearTapUp(TapUpDetails details) {
    setState(() {
      _isClearPressed = false;
    });
    widget.onClearFilters();
  }

  void _onClearTapCancel() {
    setState(() {
      _isClearPressed = false;
    });
  }

  void _onApplyTapDown(TapDownDetails details) {
    setState(() {
      _isApplyPressed = true;
    });
  }

  void _onApplyTapUp(TapUpDetails details) {
    setState(() {
      _isApplyPressed = false;
    });
    Navigator.pop(context);
  }

  void _onApplyTapCancel() {
    setState(() {
      _isApplyPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.8,
      minChildSize: 0.4,
      builder: (context, scrollController) => FadeTransition(
        opacity: const AlwaysStoppedAnimation(1.0), // Fade animation placeholder
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[50]!,
                Colors.white,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                      title: 'Display Mode',
                      content: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Courses'),
                            leading: Radio<bool>(
                              value: false,
                              groupValue: widget.isTeacherMode,
                              onChanged: (value) {
                                widget.onModeChanged(false);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Teachers'),
                            leading: Radio<bool>(
                              value: true,
                              groupValue: widget.isTeacherMode,
                              onChanged: (value) {
                                widget.onModeChanged(true);
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
                            Slider(
                              value: widget.currentPriceFilter,
                              min: 0,
                              max: widget.maxPrice,
                              divisions: 10,
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey[300],
                              onChanged: widget.onPriceFilterChanged,
                              onChangeEnd: (value) => widget.onPriceFilterApplied(),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTapDown: _onClearTapDown,
                            onTapUp: _onClearTapUp,
                            onTapCancel: _onClearTapCancel,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              transform: Matrix4.identity()..scale(_isClearPressed ? 0.96 : 1.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12),
                                color: _isClearPressed ? Colors.blue[50] : Colors.white,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                splashColor: Colors.blue.withOpacity(0.3),
                                highlightColor: Colors.transparent,
                                onTap: () {}, // Handled by GestureDetector
                                child: Center(
                                  child: Text(
                                    'Clear All',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: _onApplyTapDown,
                            onTapUp: _onApplyTapUp,
                            onTapCancel: _onApplyTapCancel,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              transform: Matrix4.identity()..scale(_isApplyPressed ? 0.96 : 1.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _isApplyPressed
                                      ? [Colors.blue[600]!, Colors.blueAccent[700]!]
                                      : [Colors.blue, Colors.blueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(_isApplyPressed ? 0.2 : 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                splashColor: Colors.white.withOpacity(0.3),
                                highlightColor: Colors.transparent,
                                onTap: () {}, // Handled by GestureDetector
                                child: const Center(
                                  child: Text(
                                    'Apply',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
      ),
    );
  }
}