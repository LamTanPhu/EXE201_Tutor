import 'package:flutter/material.dart';
import 'package:tutor/common/models/certification.dart';

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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Certifications',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: onAddCertification,
                  icon: const Icon(Icons.add_circle),
                  color: Theme.of(context).primaryColor,
                  tooltip: 'Add Certification',
                ),
              ],
            ),
            const SizedBox(height: 12),
            certifications?.isEmpty ?? true
                ? const Text('No certifications added yet.')
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: certifications?.length ?? 0,
                  itemBuilder: (context, index) {
                    final cert = certifications![index];
                    return ListTile(
                      leading: const Icon(Icons.verified),
                      title: Text(cert.name ?? 'Unkown Certification'),
                      subtitle: Text(cert.description ?? ''),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
