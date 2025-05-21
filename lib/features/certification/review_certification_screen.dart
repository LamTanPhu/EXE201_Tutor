import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ReviewCertificationScreen extends StatefulWidget {
  const ReviewCertificationScreen({super.key});

  @override
  State<ReviewCertificationScreen> createState() =>
      _ReviewCertificationScreenState();
}

class _ReviewCertificationScreenState extends State<ReviewCertificationScreen> {
  //Fake data from JSON
  List<Map<String, dynamic>> certifications = [
    {
      "_id": "cert_001",
      "name": "Bằng Cử nhân Sư phạm Toán",
      "description": "Bằng cấp từ Đại học Sư phạm Hà Nội",
      "image": ["https://example.com/certificates/math_degree.jpg"],
      "experience": 5,
      "isChecked": true,
      "isCanTeach": true,
      "createBy": "tutor_123",
    },
    {
      "_id": "cert_002",
      "name": "Chứng chỉ TOEIC 900",
      "description": "Chứng chỉ tiếng Anh quốc tế",
      "image": ["https://example.com/certificates/toeic_900.jpg"],
      "experience": 2,
      "isChecked": false,
      "isCanTeach": false,
      "createBy": "tutor_123",
    },
  ];

  final TextEditingController _rejectionReasonController =
      TextEditingController();

  //aprove certification
  void _approveCertificate(int id) {
    setState(() {
      certifications[id]['isChecked'] = true;
      certifications[id]['isCanTeach'] = true;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Certification is approved')));
  }

  //reject certification
  void _rejectCertificate(int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reason'),
            content: TextField(
              controller: _rejectionReasonController,
              decoration: const InputDecoration(
                labelText: 'Enter the reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    certifications[id]['isChecked'] = false;
                    certifications[id]['isCanTeach'] = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Reject certifaction with reason: ${_rejectionReasonController.text}',
                      ),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pending Certificates',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: certifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: certifications[index]['image'].isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: certifications[index]['image'][0],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          : const Icon(Icons.description),
                      title: Text(certifications[index]['name']),
                      subtitle: Text(
                        'Description: ${certifications[index]['description']}\n'
                        'Experience: ${certifications[index]['experience']} years\n'
                        'Status: ${certifications[index]['isChecked'] ? 'Approved' : 'Pending'}\n'
                        'Can Teach: ${certifications[index]['isCanTeach'] ? 'Yes' : 'No'}\n'
                        'Submitted by: ${certifications[index]['createBy']}',
                      ),
                      trailing: certifications[index]['isChecked']
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: () => _approveCertificate(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _rejectCertificate(index),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
