import 'package:flutter/material.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/common/widgets/custom_loading.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/admin/screens/reports_screen.dart'; 

class TopAccountWidget extends StatefulWidget {
  const TopAccountWidget({super.key});

  @override
  State<TopAccountWidget> createState() => _TopAccountWidgetState();
}

class _TopAccountWidgetState extends State<TopAccountWidget> {
  late final Future<TopAccount> _topAccountFuture;

  @override
  void initState() {
    super.initState();
    _topAccountFuture = ApiService.getTopAccountReport();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B35),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Giảng viên xuất sắc',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Gia sư hàng đầu theo các khóa học',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<TopAccount>(
                future: _topAccountFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomLoading();
                  } else if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  } else if (!snapshot.hasData) {
                    return _buildEmptyState();
                  }

                  final account = snapshot.data!;
                  return _buildAccountCard(account);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Không thể tải dữ liệu',
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            error,
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_search_rounded,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Chưa có dữ liệu',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Không tìm thấy giảng viên nào',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(TopAccount account) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar with trophy
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade400,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Account info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '#1',
                            style: TextStyle(
                              color: Colors.amber.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  account.fullName ?? 'Không có tên',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  account.email ?? 'Không có email',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${account.completedCourses ?? 0} khóa học',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}