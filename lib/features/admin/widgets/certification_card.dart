import 'package:flutter/material.dart';
import 'package:tutor/common/models/certification.dart';

class CertificationCard extends StatelessWidget {
  final Certification certification;

  const CertificationCard({super.key, required this.certification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(certification.image.first, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(certification.name ?? "N/A"),
        subtitle: Text(certification.description ?? "N/A"),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Exp: ${certification.experience} yr'),
            Text(certification.isChecked == true ? 'Checked' : 'Unchecked'),
            Text(certification.isCanTeach == true ? 'Can Teach' : 'Cannot Teach'),
          ],
        ),
      ),
    );
  }
}
