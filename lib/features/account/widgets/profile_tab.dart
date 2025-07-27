import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/models/account_detail.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/features/account/widgets/cert_tab.dart';
import 'package:tutor/features/account/widgets/info_tab.dart';

class ProfileTabSection extends StatelessWidget {
  final Account profileData;
  final List<Certification> certifications;
  final TabController tabController;

  const ProfileTabSection({
    super.key,
    required this.profileData,
    required this.tabController,
    required this.certifications
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: AppColors.primaryGradient,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.all(8),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.subText,
            tabs: const [
              Tab(text: 'Thông tin'),
              Tab(text: 'Chứng chỉ'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: tabController,
              children: [
                InfoTab(profileData: profileData),
                CertificationsTab(data: certifications),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
