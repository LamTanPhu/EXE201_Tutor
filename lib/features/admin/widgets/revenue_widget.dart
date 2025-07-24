import 'package:flutter/material.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/common/widgets/custom_loading.dart';
import 'package:tutor/features/admin/widgets/barchart_widget.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/admin/screens/reports_screen.dart'; // Import để sử dụng CommonLoadingWidget

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildContent(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doanh thu năm ${widget.year}',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('Thống kê theo tháng', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text('${widget.year}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: FutureBuilder<RevenueData>(
        future: _revenueFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoading();
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data!.revenue.isNotEmpty) {
            return _buildChartContent(snapshot.data!);
          } else {
            return _buildEmptyState();
          }
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text('Không thể tải dữ liệu doanh thu', style: TextStyle(color: Colors.red.shade700, fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(error, style: TextStyle(color: Colors.red.shade600, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text('Chưa có dữ liệu doanh thu', style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w600)),
          Text('Dữ liệu sẽ hiển thị khi có giao dịch', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildChartContent(RevenueData revenueData) {
    final revenueList = revenueData.revenue;

    // Lấy danh sách doanh thu từng tháng
    final values = List.generate(
      12,
      (index) => revenueList.firstWhere(
        (item) => item.month == index,
        orElse: () => MonthlyRevenue(month: index, revenue: 0),
      ).revenue,
    );

    final labels = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];

    // Thống kê tổng, trung bình, cao nhất
    final totalRevenue = values.fold<double>(0, (sum, value) => sum + value);
    final avgRevenue = totalRevenue / 12;
    final maxRevenue = values.reduce((a, b) => a > b ? a : b);
    final maxMonth = labels[values.indexOf(maxRevenue)];

    return Column(
      children: [
        // Thống kê doanh thu
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            children: [
              Expanded(child: _buildStatItem('Tổng doanh thu', _formatCurrency(totalRevenue), Icons.attach_money_rounded, Colors.green)),
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              Expanded(child: _buildStatItem('Trung bình/tháng', _formatCurrency(avgRevenue), Icons.trending_up_rounded, Colors.blue)),
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              Expanded(child: _buildStatItem('Cao nhất ($maxMonth)', _formatCurrency(maxRevenue), Icons.star_rounded, Colors.orange)),
            ],
          ),
        ),

        // Biểu đồ
        SizedBox(
          height: 300,
          child: BarChartWidget(
            values: values,
            labels: labels,
            xAxisLabel: 'Tháng',
            yAxisLabel: 'Doanh thu (₫)',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 10), textAlign: TextAlign.center),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1e9) return '${(amount / 1e9).toStringAsFixed(1)}B';
    if (amount >= 1e6) return '${(amount / 1e6).toStringAsFixed(1)}M';
    if (amount >= 1e3) return '${(amount / 1e3).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }
}