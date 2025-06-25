import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/features/certification/submit_certificate_screen.dart';
import 'package:tutor/services/api_service.dart';

class CertificationScreen extends StatefulWidget {
  const CertificationScreen({super.key});

  @override
  State<CertificationScreen> createState() => _CertificationScreenState();
}

class _CertificationScreenState extends State<CertificationScreen> {
  late Future<List<Certification>> _certificationFuture;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _certificationFuture = _fetchCertifications();
  }

  Future<List<Certification>> _fetchCertifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getString('accountId');
      if (accountId == null) {
        throw Exception('Account ID not found');
      }
      final response = await ApiService.getAccountDetails(accountId);

      // Check if response['data'] and response['data']['certifications'] exist
      if (response['data'] == null ||
          response['data']['certifications'] == null ||
          response['data']['certifications'] is! List) {
        return []; // Return empty list if certifications is null or not a list
      }

      // Safely map the certifications
      final List<Certification> certifications =
          (response['data']['certifications'] as List<dynamic>)
              .map<Certification>((certification) {
                return Certification.fromJson(certification);
              })
              .toList();
      return certifications;
    } catch (e) {
      throw Exception('Failed to fetch certifications: $e');
    }
  }

  void _refreshCertifications() {
    setState(() {
      _certificationFuture = _fetchCertifications();
    });
  }

  List<Certification> _filterCertifications(
    List<Certification> certifications,
  ) {
    if (_searchText.isEmpty) {
      return certifications;
    }
    return certifications.where((certification) {
      return (certification.name?.toLowerCase() ?? '').contains(
        _searchText.toLowerCase(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chứng chỉ đã nộp')),
      body: FutureBuilder<List<Certification>>(
        future: _certificationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final certifications = _filterCertifications(snapshot.data ?? []);
          if (certifications.isEmpty) {
            return const Center(child: Text('Không có chứng chỉ nào.'));
          }
          return ListView.builder(
            itemCount: certifications.length,
            itemBuilder: (context, index) {
              final cert = certifications[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading:
                      cert.image.isNotEmpty
                          ? Image.network(
                            cert.image.first,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Icon(Icons.image),
                          )
                          : const Icon(Icons.image, size: 50),

                  title: Text(cert.name ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cert.description ?? ''),
                      Text('Kinh nghiệm: ${cert.experience ?? 0} năm'),
                      Row(
                        children: [
                          Icon(
                            (cert.isChecked ?? false)
                                ? Icons.verified
                                : Icons.hourglass_empty,
                            color:
                                (cert.isChecked ?? false)
                                    ? Colors.green
                                    : Colors.orange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            (cert.isChecked ?? false)
                                ? ((cert.isCanTeach ?? false)
                                    ? 'Đã duyệt'
                                    : 'Bị từ chối')
                                : 'Đang chờ xét duyệt',
                          ),
                        ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SubmitCertificationScreen()),
          );
          if (result == true) {
            // Reload
            setState(() {
              _refreshCertifications();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
