// features/reports/widgets/revenue_widget.dart
import 'package:flutter/material.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/features/admin/widgets/barchart_widget.dart';
import 'package:tutor/services/api_service.dart';

class RevenueWidget extends StatefulWidget {
  final int year;

  const RevenueWidget({super.key, required this.year});

  @override
  State<RevenueWidget> createState() => _RevenueWidgetState();
}

class _RevenueWidgetState extends State<RevenueWidget> {
  late Future<RevenueData> _revenueFuture;

  @override
  void initState() {
    super.initState();
    _revenueFuture = ApiService.getRevenueReport(widget.year);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Report (${widget.year})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<RevenueData>(
              future: _revenueFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.revenue.isNotEmpty) {
                  final revenueList = snapshot.data!.revenue;

                  final values = List.generate(
                    12,
                    (index) => revenueList.firstWhere(
                      (item) => item.month == index,
                      orElse: () => MonthlyRevenue(month: index, revenue: 0),
                    ).revenue,
                  );

                  final labels = [
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                  ];

                  return BarChartWidget(
                    values: values,
                    labels: labels,
                    xAxisLabel: 'Month',
                    yAxisLabel: 'Revenue (₫)',
                  );
                } else {
                  return const Text('No revenue data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
