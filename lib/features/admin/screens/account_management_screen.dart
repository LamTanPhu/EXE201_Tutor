import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/tutor.dart';
import 'package:tutor/common/widgets/custom_loading.dart';
import 'package:tutor/common/widgets/custom_search_bar.dart';
import 'package:tutor/features/admin/screens/account_detail_screen.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/common/theme/app_colors.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  late Future<List<Tutor>> _tutorsFuture;

  @override
  void initState() {
    super.initState();
    _tutorsFuture = ApiService.getTutors();
  }

  void _refreshTutors() {
    setState(() {
      _tutorsFuture = ApiService.getTutors();
    });
  }

  void _handleClearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
    // Load lại danh sách đầy đủ
  }

  List<Tutor> _filterTutors(List<Tutor> tutors) {
    if (_searchQuery.isEmpty) return tutors;
    return tutors.where((tutor) {
      final name = tutor.account.fullName?.toLowerCase() ?? '';
      final email = tutor.account.email?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Danh sách gia sư',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.lightPrimary],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTutors,
            tooltip: 'Làm mới',
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          CustomSearchBar(
            hintText: 'Tìm kiếm gia sư theo tên hoặc email...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onClear: _handleClearSearch,
          ),
          // Danh sách gia sư
          Expanded(
            child: FutureBuilder<List<Tutor>>(
              future: _tutorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomLoading();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Lỗi: ${snapshot.error}',
                          style: const TextStyle(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshTutors,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off,
                          size: 64,
                          color: AppColors.subText,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Không tìm thấy gia sư nào',
                          style: TextStyle(color: AppColors.text, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                final filteredTutors = _filterTutors(snapshot.data!);

                if (filteredTutors.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.subText,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Không tìm thấy gia sư phù hợp',
                          style: TextStyle(color: AppColors.text, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredTutors.length,
                  itemBuilder: (context, index) {
                    final tutor = filteredTutors[index];
                    return _buildTutorCard(tutor);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorCard(Tutor tutor) {
    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 4,
      shadowColor: AppColors.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.card,
              AppColors.backgroundGradientStart.withOpacity(0.3),
            ],
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child:
                tutor.account.avatar != null && tutor.account.avatar!.isNotEmpty
                    ? CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.background,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: tutor.account.avatar!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => const CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                          errorWidget:
                              (context, url, error) => const Icon(
                                Icons.person,
                                color: AppColors.subText,
                                size: 32,
                              ),
                        ),
                      ),
                    )
                    : CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.lightPrimary,
                      child: Text(
                        (tutor.account.fullName?.isNotEmpty == true
                            ? tutor.account.fullName![0].toUpperCase()
                            : '?'),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
          ),
          title: Text(
            tutor.account.fullName ?? 'Chưa có tên',
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                tutor.account.email ?? 'Chưa có email',
                style: const TextStyle(color: AppColors.subText, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          tutor.account.status == 'Active'
                              ? Colors.green.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                tutor.account.status == 'Active'
                                    ? Colors.green
                                    : AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tutor.account.status == 'Active'
                              ? 'Hoạt động'
                              : 'Không hoạt động',
                          style: TextStyle(
                            color:
                                tutor.account.status == 'Active'
                                    ? Colors.green[700]
                                    : AppColors.error,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 16,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        AccountDetailScreen(accountId: tutor.account.id),
              ),
            );
          },
        ),
      ),
    );
  }
}
