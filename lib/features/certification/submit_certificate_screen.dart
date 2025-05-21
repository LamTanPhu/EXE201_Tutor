import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubmitCertificateScreen extends StatefulWidget {
  final String tutorId;
  const SubmitCertificateScreen({super.key, required this.tutorId});

  @override
  State<SubmitCertificateScreen> createState() => _SubmitCertificateScreenState();
}

class _SubmitCertificateScreenState extends State<SubmitCertificateScreen> {
final TextEditingController _certificateNameController = TextEditingController();
  final TextEditingController _certificateDateController = TextEditingController();
  final TextEditingController _certificateDescController = TextEditingController();
  String? _selectedFilePath;
  String? _fileName;

  Future<void> _pickCertificateFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _selectedFilePath = "https://example.com/certificates/$_fileName"; // Simulate URL
      });
    }
  }

  void _submitCertificate() {
    if (_certificateNameController.text.isEmpty || _selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a certificate name and file')),
      );
      return;
    }

    final newCertificate = {
      "_id": "cert_${DateTime.now().millisecondsSinceEpoch}",
      "name": _certificateNameController.text.isNotEmpty
          ? _certificateNameController.text
          : _fileName,
      "description": _certificateDescController.text,
      "image": [_selectedFilePath],
      "experience": 0,
      "isChecked": false,
      "isCanTeach": false,
      "createBy": widget.tutorId,
      "rejectionReason": "",
      "issueDate": _certificateDateController.text,
    };

    Navigator.pop(context, newCertificate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Certificate'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Certificate Image Preview
            const Text(
              'Certificate Preview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: _selectedFilePath != null
                  ? Image.network(
                      _selectedFilePath!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100),
                    )
                  : Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 100, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _pickCertificateFile,
                child: const Text('Select Certificate File'),
              ),
            ),
            const SizedBox(height: 20),

            // Certificate Details
            const Text(
              'Certificate Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _certificateNameController,
              decoration: const InputDecoration(
                labelText: 'Certificate Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _certificateDateController,
              decoration: const InputDecoration(
                labelText: 'Issuance Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _certificateDescController,
              decoration: const InputDecoration(
                labelText: 'Certificate Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitCertificate,
                child: const Text('Submit Certificate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}