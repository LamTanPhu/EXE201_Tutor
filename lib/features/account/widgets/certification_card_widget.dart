import 'package:flutter/material.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/theme/app_colors.dart';

class CertificationCardWidget extends StatelessWidget {
  final List<Certification>? certifications;
  final VoidCallback onAddCertification;

  const CertificationCardWidget({
    super.key,
    this.certifications,
    required this.onAddCertification,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [AppColors.lightPrimary, AppColors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Certifications',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  onPressed: onAddCertification,
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.lightPrimary,
                  tooltip: 'Add Certification',
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            // Certification list
            certifications?.isEmpty ?? true
                ? Center(
                  child: Text(
                    'No certifications added yet.',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
                : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: certifications!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cert = certifications![index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.workspace_premium,
                          color: Colors.orange,
                        ),
                        title: Text(cert.name ?? 'Unknown Certification'),
                        subtitle: Text(cert.description ?? ''),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
