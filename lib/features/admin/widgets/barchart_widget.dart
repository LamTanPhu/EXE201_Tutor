// common/widgets/bar_chart_widget.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/utils/currency.dart';

class BarChartWidget extends StatelessWidget {
  final List<double> values; // Dữ liệu trục Y
  final List<String> labels; // Nhãn trục X
  final String xAxisLabel; // Tên trục X
  final String yAxisLabel; // Tên trục Y
  final double? maxY; // Giới hạn tối đa Y

  const BarChartWidget({
    super.key,
    required this.values,
    required this.labels,
    required this.xAxisLabel,
    required this.yAxisLabel,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue =
        maxY ??
        (values.isNotEmpty
            ? (values.reduce((a, b) => a > b ? a : b) * 1.2)
            : 100);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: 300,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            maxY: maxValue,
            barGroups: List.generate(values.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: values[index],
                    width: 10,
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
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
                      CurrencyUtils.formatNumber(value),
                      style: const TextStyle(fontSize: 7),
                    );
                  },
                ),
                axisNameWidget: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    yAxisLabel,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        labels[value.toInt()],
                        style: const TextStyle(fontSize: 8),
                      ),
                    );
                  },
                ),
                axisNameWidget: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    xAxisLabel,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true),
          ),
        ),
      ),
    );
  }
}
