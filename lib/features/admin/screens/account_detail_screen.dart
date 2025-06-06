import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/models/account_detail.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/features/admin/widgets/certification_card.dart';
import 'package:tutor/features/admin/widgets/course_card.dart';

class AccountDetailScreen extends StatelessWidget {
  const AccountDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockAccount = Account(
      id: '1',
      fullName: 'John Doe',
      email: 'john@example.com',
      phone: '123456789',
      status: 'Active',
      role: 'Tutor',
    );

    final mockCerts = [
      Certification(
        id: 'c1',
        name: 'TOEIC 900',
        description: 'English proficiency certification',
        image: ['https://via.placeholder.com/150'],
        experience: 3,
        isChecked: true,
        isCanTeach: true,
        createBy: 'admin',
      ),
    ];

    final mockCourses = [
      Course(
        id: 'cs1',
        name: 'Basic English',
        description: 'Introduction to English',
        image: 'https://via.placeholder.com/150',
        price: 100,
        isActive: true,
        createdBy: 'tutor123',
        createdAt: DateTime.now(),
      ),
    ];

    final mockAccountDetail = AccountDetail(
      account: mockAccount,
      certifications: mockCerts,
      courses: mockCourses,
    );

    final detail = mockAccountDetail;
    final account = detail.account;

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
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
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
      ),
      )
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

  Widget _buildCertsTab(AccountDetail detail) {
    if (detail.certifications.isEmpty) {
      return const Center(child: Text("No certifications."));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children:
          detail.certifications
              .map((c) => CertificationCard(certification: c))
              .toList(),
    );
  }

  Widget _buildCoursesTab(AccountDetail detail) {
    if (detail.courses.isEmpty) {
      return const Center(child: Text("No courses."));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: detail.courses.map((c) => CourseCard(course: c)).toList(),
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
