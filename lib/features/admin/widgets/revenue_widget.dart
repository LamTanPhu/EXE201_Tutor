// features/reports/widgets/revenue_widget.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/statistic_data.dart';
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
                  final revenue = snapshot.data!.revenue;
                  final revenueData = revenue.map((r) => r.revenue ?? 0).toList();
                  if (revenueData.length != 12) {
                    return const Text('Invalid revenue data: Expected 12 months');
                  }
                  return SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: List.generate(12, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: revenueData[index],
                                color: const Color(0xFF42A5F5),
                                borderRadius: BorderRadius.zero,
                              ),
                            ],
                          );
                        }),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '\$${value.toInt()}',
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                            axisNameWidget: const Text('Revenue (VND)'),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const months = [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun',
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                  'Oct',
                                  'Nov',
                                  'Dec'
                                ];
                                return Text(
                                  months[value.toInt()],
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                            axisNameWidget: const Text('Month'),
                          ),
                          topTitles: const AxisTitles(),
                          rightTitles: const AxisTitles(),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  );
                }
                return const Text('No revenue data available');
              },
            ),
            // Fallback table
            const SizedBox(height: 16),
            FutureBuilder<RevenueData>(
              future: _revenueFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.revenue.isEmpty) {
                  return const SizedBox.shrink();
                }
                final revenue = snapshot.data!.revenue;
                return Table(
                  border: TableBorder.all(),
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(color: Colors.grey),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Month', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Revenue', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...revenue.map((month) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(month.month?.toString() ?? 'N/A'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text('\$${month.revenue?.toStringAsFixed(2) ?? '0.00'}'),
                            ),
                          ],
                        )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}