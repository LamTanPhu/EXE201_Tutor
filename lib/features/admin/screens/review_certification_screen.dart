import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/models/tutor.dart';
import 'package:tutor/services/api_service.dart';

class ReviewCertificationScreen extends StatefulWidget {
  const ReviewCertificationScreen({super.key});

  @override
  State<ReviewCertificationScreen> createState() =>
      _ReviewCertificationScreenState();
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
        tutor.certifications
            .where(
              (cert) => cert.isChecked == false && cert.isCanTeach == false,
            )
            .toList(),
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
      // Corrected method names
      await ApiService.checkCertification(certificationId);
      await ApiService.checkCertificationToTeach(certificationId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certification approved successfully!')),
      );
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
        print(e);
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _showCertificationDetails(BuildContext context, Certification cert) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(cert.name ?? 'Unnamed Certification'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cert.image.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: cert.image.first,
                      width: 100,
                      height: 100,
                      placeholder:
                          (context, url) => const CircularProgressIndicator(),
                      errorWidget:
                          (context, url, error) => const Icon(Icons.error),
                    ),
                  const SizedBox(height: 8),
                  Text('Description: ${cert.description ?? 'N/A'}'),
                  Text('Created by: ${cert.createBy ?? 'Unknown'}'),
                  Text('Experience: ${cert.experience ?? 0} years'),
                  Text('Checked: ${cert.isChecked ?? false ? 'Yes' : 'No'}'),
                  Text('Can Teach: ${cert.isCanTeach ?? false ? 'Yes' : 'No'}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _approveCertification(cert.id);
                  Navigator.pop(context); // Close dialog after approval
                },
                child: const Text('Approve'),
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
              return const Center(
                child: Text('No certifications pending approval'),
              );
            }
            return ListView.builder(
              itemCount: certifications.length,
              itemBuilder: (context, index) {
                final cert = certifications[index];
                return ListTile(
                  title: Text(cert.name ?? 'Unnamed Certification'),
                  subtitle: Text(cert.description ?? 'N/A'),
                  leading:
                      cert.image.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: cert.image.first,
                            width: 50,
                            height: 50,
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          )
                          : const Icon(Icons.image),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed:
                            () => _showCertificationDetails(context, cert),
                        tooltip: 'View Details',
                      ),
                      ElevatedButton(
                        onPressed: () => _approveCertification(cert.id),
                        child: const Text('Approve'),
                      ),
                    ],
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
