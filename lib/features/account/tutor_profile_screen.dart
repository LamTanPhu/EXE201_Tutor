import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';



class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  _TutorProfileScreenState createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  // Fake data for tutor profile
  Map<String, dynamic> tutorData = {
    "account": {
      "fullName": "Nguyễn Văn A",
      "email": "nguyenvana@example.com",
      "phone": "0123456789",
      "role": "Tutor",
      "status": "Active",
      "avatar": "https://example.com/avatars/nguyenvana.jpg",
      "balance": 1500000.0,
      "createdAt": "2025-05-21T02:23:37.540Z"
    },
    "certifications": [
      {
        "name": "Bằng Cử nhân Sư phạm Toán",
        "description": "Bằng cấp từ Đại học Sư phạm Hà Nội",
        "image": ["https://example.com/certificates/math_degree.jpg"],
        "experience": 5,
        "isChecked": true,
        "isCanTeach": true,
      },
      {
        "_id": "cert_002",
        "name": "Chứng chỉ TOEIC 900",
        "description": "Chứng chỉ tiếng Anh quốc tế",
        "image": ["https://example.com/certificates/toeic_900.jpg"],
        "experience": 2,
        "isChecked": false,
        "isCanTeach": false,
        "createBy": "tutor_123"
      }
    ]
  };

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _certificateNameController = TextEditingController();
  final TextEditingController _certificateDateController = TextEditingController();
  final TextEditingController _certificateDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with fake data
    _nameController.text = tutorData['account']['fullName'];
    _emailController.text = tutorData['account']['email'];
    _phoneController.text = tutorData['account']['phone'];
  }

  // Function to simulate file upload
  Future<void> _uploadCertificate() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      String fileName = result.files.single.name;
      setState(() {
        tutorData['certifications'].add({
          "_id": "cert_${DateTime.now().millisecondsSinceEpoch}",
          "name": _certificateNameController.text.isNotEmpty
              ? _certificateNameController.text
              : fileName,
          "description": _certificateDescController.text,
          "image": ["https://example.com/certificates/$fileName"],
          "experience": 0,
          "isChecked": false,
          "isCanTeach": false,
          "createBy": tutorData['account']['_id']
        });
        _certificateNameController.clear();
        _certificateDateController.clear();
        _certificateDescController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã nộp chứng chỉ: $fileName')),
      );
    }
  }

  // Function to simulate avatar upload
  Future<void> _uploadAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      String fileName = result.files.single.name;
      setState(() {
        tutorData['account']['avatar'] = "https://example.com/avatars/$fileName";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã cập nhật ảnh đại diện')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Section
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: _uploadAvatar,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: tutorData['account']['avatar'] != null &&
                          tutorData['account']['avatar'].isNotEmpty
                      ? CachedNetworkImageProvider(tutorData['account']['avatar'])
                      : null,
                  child: tutorData['account']['avatar'] == null ||
                          tutorData['account']['avatar'].isEmpty
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _uploadAvatar,
                child: const Text('Upload avatar'),
              ),
            ),
            const SizedBox(height: 20),

            // Balance Section
            const Text(
              'Balance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              currencyFormat.format(tutorData['account']['balance']),
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 20),

            // Personal Information Section
            const Text(
              'Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Fullname',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tutorData['account']['fullName'] = _nameController.text;
                  tutorData['account']['email'] = _emailController.text;
                  tutorData['account']['phone'] = _phoneController.text;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Update successfully')),
                );
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),

            // Certificate Upload Section
            const Text(
              'Nộp Chứng Chỉ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _certificateNameController,
              decoration: const InputDecoration(
                labelText: 'Tên Chứng Chỉ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _certificateDateController,
              decoration: const InputDecoration(
                labelText: 'Ngày Cấp (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _certificateDescController,
              decoration: const InputDecoration(
                labelText: 'Mô Tả Chứng Chỉ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadCertificate,
              child: const Text('Tải Lên Chứng Chỉ'),
            ),
            const SizedBox(height: 20),

            // Certificates List Section
            const Text(
              'Danh Sách Chứng Chỉ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            tutorData['certifications'].isEmpty
                ? const Text('Chưa có chứng chỉ nào.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tutorData['certifications'].length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: tutorData['certifications'][index]['image'].isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: tutorData['certifications'][index]['image'][0],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                )
                              : const Icon(Icons.description),
                          title: Text(tutorData['certifications'][index]['name']),
                          subtitle: Text(
                            'Mô tả: ${tutorData['certifications'][index]['description']}\n'
                            'Trạng thái: ${tutorData['certifications'][index]['isChecked'] ? 'Đã duyệt' : 'Đang chờ duyệt'}\n'
                            'Có thể dạy: ${tutorData['certifications'][index]['isCanTeach'] ? 'Có' : 'Không'}',
                          ),
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