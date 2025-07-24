import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/theme/app_colors.dart';

class AccountHeaderWidget extends StatelessWidget {
  final Account account;

  const AccountHeaderWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.lightPrimary, AppColors.backgroundGradientEnd],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.card,
              child: account.avatar != null && account.avatar!.isNotEmpty
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: account.avatar!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        errorWidget: (context, url, error) => Text(
                          account.fullName?.isNotEmpty == true
                              ? account.fullName![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      account.fullName?.isNotEmpty == true
                          ? account.fullName![0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            account.fullName ?? 'Chưa có tên',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: account.status == 'Active'
                  ? Colors.green.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              account.status == 'Active' ? 'Hoạt động' : 'Không hoạt động',
              style: TextStyle(
                color: account.status == 'Active' ? Colors.green[700] : AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}