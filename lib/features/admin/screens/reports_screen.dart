import 'package:flutter/material.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/common/widgets/custom_loading.dart';
import 'package:tutor/common/widgets/dashboard_card.dart';
import 'package:tutor/features/admin/widgets/revenue_widget.dart';
import 'package:tutor/features/admin/widgets/top_account_widget.dart';
import 'package:tutor/services/api_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Future<DashboardCombinedData> fetchDashboardData() async {
    try {
      final results = await Future.wait([
        ApiService.getAccountStatusReport(),
        ApiService.getCourseStatusReport(),
      ]);

      return DashboardCombinedData(
        accountStatus: results[0],
        courseStatus: results[1],
      );
    } catch (e) {
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFFFFFFF),
              Color(0xFFF3E5F5),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with gradient
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Báo cáo & Thống kê',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                        Color(0xFF90CAF9),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Content
            SliverToBoxAdapter(
              child: FutureBuilder<DashboardCombinedData>(
                future: fetchDashboardData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomLoading();
                  }

                  if (snapshot.hasError) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Lỗi: ${snapshot.error}',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không có dữ liệu',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final data = snapshot.data!;
                  final stats = [
                    DashboardStat(
                      title: 'Tài khoản hoạt động',
                      value: data.accountStatus.active,
                      icon: Icons.people_alt_rounded,
                    ),
                    DashboardStat(
                      title: 'Khóa học hiện có',
                      value: data.courseStatus.active,
                      icon: Icons.school_rounded,
                    ),
                  ];

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Statistics Cards
                        _buildSectionTitle('Tổng quan hệ thống', Icons.dashboard_rounded),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: stats.length,
                          itemBuilder: (context, index) {
                            return _buildStatCard(stats[index], index);
                          },
                        ),
                        const SizedBox(height: 32),
                        // Revenue Section
                        _buildSectionTitle('Doanh thu', Icons.trending_up_rounded),
                        const SizedBox(height: 16),
                        _buildRevenueWidget(currentYear),
                        const SizedBox(height: 32),
                        // Top Account Section
                        _buildSectionTitle('Bảng xếp hạng', Icons.emoji_events_rounded),
                        const SizedBox(height: 16),
                        const TopAccountWidget(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(DashboardStat stat, int index) {
    final colors = [
      const Color(0xFF1976D2),
      const Color(0xFFE91E63),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              stat.icon,
              color: Colors.white,
              size: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stat.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat.title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueWidget(int year) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: RevenueWidget(year: year),
      ),
    );
  }
}