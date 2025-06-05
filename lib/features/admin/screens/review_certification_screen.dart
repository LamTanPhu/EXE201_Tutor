import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/models/tutor.dart';
import 'package:tutor/services/api_service.dart';

class ReviewCertificationScreen extends StatefulWidget {
  const ReviewCertificationScreen({super.key});

  @override
  State<ReviewCertificationScreen> createState() => _ReviewCertificationScreenState();
}

class _ReviewCertificationScreenState extends State<ReviewCertificationScreen> {
  late Future<List<Tutor>> _tutorsFuture;

  @override
  void initState() {
    super.initState();
    _tutorsFuture = ApiService.getTutors();
  }

  List<Certification> filterPendingCertifications(List<Tutor> tutors) {
    final certifications = <Certification>[];
    for (var tutor in tutors) {
      certifications.addAll(
        tutor.certifications.where(
              (cert) => cert.isChecked == false && cert.isCanTeach == false,
        ),
      );
    }
    return certifications;
  }

  Future<void> _approveCertification(String? certificationId) async {
    if (certificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Certification ID is missing')),
      );
      return;
    }

    try {
      await ApiService.checkCertification(certificationId);
      await ApiService.checkCertificationToTeach(certificationId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certification approved successfully!')),
      );
      setState(() {
        _tutorsFuture = ApiService.getTutors(); // refresh after approval
      });
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('endpoint not found')) {
        errorMessage = 'Error: Certification approval service is unavailable';
      } else if (e.toString().contains('Unauthorized')) {
        errorMessage = 'Error: Session expired. Please log in again';
      } else if (e.toString().contains('Invalid response format')) {
        errorMessage = 'Error: Invalid server response. Please try again later';
      } else {
        errorMessage = 'Error: $e';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _showCertificationDetails(BuildContext context, Certification cert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cert.name ?? 'Unnamed Certification'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cert.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: cert.image.first,
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              const SizedBox(height: 12),
              Text('Description: ${cert.description ?? 'N/A'}'),
              Text('Created by: ${cert.createBy ?? 'Unknown'}'),
              Text('Experience: ${cert.experience ?? 0} years'),
              Text('Checked: ${cert.isChecked == true ? 'Yes' : 'No'}'),
              Text('Can Teach: ${cert.isCanTeach == true ? 'Yes' : 'No'}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await _approveCertification(cert.id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Approve'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approve Certifications')),
      body: FutureBuilder<List<Tutor>>(
        future: _tutorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final certifications = filterPendingCertifications(snapshot.data!);
            if (certifications.isEmpty) {
              return const Center(child: Text('No certifications pending approval'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: certifications.length,
              itemBuilder: (context, index) {
                final cert = certifications[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showCertificationDetails(context, cert),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: cert.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: cert.image.first,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : const Icon(Icons.image, size: 60),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cert.name ?? 'Unnamed Certification',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cert.description ?? 'No description',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No tutors found'));
        },
      ),
    );
  }
}
