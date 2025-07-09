import 'package:flutter/material.dart';
import 'package:tutor/common/models/tutor.dart';
import 'package:tutor/common/widgets/list_view_widget.dart';
import 'package:tutor/features/admin/screens/account_detail_screen.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/common/theme/app_colors.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('List of Tutors', style: TextStyle(color: AppColors.primary)),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: FutureBuilder<List<Tutor>>(
        future: ApiService.getTutors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: AppColors.error)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tutors found', style: TextStyle(color: AppColors.subText)));
          }


          return ListViewWidget<Tutor>(
            items: snapshot.data!,
            itemBuilder: (tutor) {
              return Card(
                color: AppColors.card,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: tutor.account.avatar != null && tutor.account.avatar!.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(tutor.account.avatar!),
                          radius: 24,
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(
                    tutor.account.fullName ?? 'No Name',
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${tutor.account.email}',
                    style: const TextStyle(color: AppColors.subText, fontSize: 9),
                  ),
                  trailing: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tutor.account.status == 'Active'
                          ? Colors.green
                          : AppColors.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountDetailScreen(accountId: tutor.account.id))
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}