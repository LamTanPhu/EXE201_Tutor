import 'package:flutter/material.dart';
import 'package:tutor/common/models/account_detail.dart';
import 'package:tutor/features/admin/widgets/account_header.dart';
import 'package:tutor/features/admin/widgets/cert_tab_widget.dart';
import 'package:tutor/features/admin/widgets/course_tab_widget.dart';
import 'package:tutor/features/admin/widgets/infor_tab_widget.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/common/theme/app_colors.dart';

class AccountDetailScreen extends StatelessWidget {
  final String accountId;

  const AccountDetailScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Chi tiết tài khoản',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
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
          bottom: TabBar(
            indicatorColor: AppColors.white,
            indicatorWeight: 3,
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.white.withOpacity(0.7),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: "Thông tin"),
              Tab(text: "Chứng chỉ"),
              Tab(text: "Khóa học"),
            ],
          ),
        ),
        body: FutureBuilder<AccountDetail>(
          future: ApiService.getCourseByAccount(accountId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (snapshot.hasError) {
              print(snapshot.data);
                            print(snapshot.error);

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
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 64,
                      color: AppColors.subText,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Không có dữ liệu',
                      style: TextStyle(color: AppColors.text),
                    ),
                  ],
                ),
              );
            }

            final detail = snapshot.data!;
            return Column(
              children: [
                AccountHeaderWidget(account: detail.account),
                Expanded(
                  child: TabBarView(
                    children: [
                      InfoTabWidget(account: detail.account),
                      CertsTabWidget(certifications: detail.certifications),
                      CoursesTabWidget(courses: detail.courses),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
