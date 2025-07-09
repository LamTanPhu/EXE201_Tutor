import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/models/account_detail.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/features/admin/widgets/certification_card.dart';
import 'package:tutor/features/admin/widgets/course_card.dart';
import 'package:tutor/services/api_service.dart';

class AccountDetailScreen extends StatelessWidget {
  //Pass accountId to fetch courses
  final String accountId;
  const AccountDetailScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Detail'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Infor"),
              Tab(text: "Certifications"),
              Tab(text: "Courses"),
            ],
          ),
        ),
        body: FutureBuilder<AccountDetail>(
          future: ApiService.getCourseByAccount(accountId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }

            final detail = snapshot.data!;
            final account = detail.account;

            return Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      account.avatar ??
                          'https://ui-avatars.com/api/?name=${account.fullName}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildInfoTab(account),
                      _buildCertsTab(detail),
                      _buildCoursesTab(detail),
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

  Widget _buildInfoTab(Account account) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _infoRow('Full Name', account.fullName ?? "N/A"),
      _infoRow('Email', account.email ?? "N/A"),
      _infoRow('Phone', account.phone ?? "N/A"),
      _infoRow('Status', account.status ?? "N/A"),
      _infoRow('Role', account.role ?? "N/A"),
    ],
  );

  Widget _buildCertsTab(AccountDetail item) {
    if (item.certifications.isEmpty) {
      return const Center(child: Text("No certifications."));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children:
          item.certifications
              .map((c) => CertificationCard(certification: c))
              .toList(),
    );
  }

  Widget _buildCoursesTab(AccountDetail item) {
    if (item.courses.isEmpty) {
      return const Center(child: Text("No courses."));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: item.courses.map((c) => CourseCard(course: c)).toList(),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
