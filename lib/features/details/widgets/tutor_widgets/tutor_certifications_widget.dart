import 'package:flutter/material.dart';

class TutorCertificationsWidget extends StatelessWidget {
  final List<dynamic> certifications;

  const TutorCertificationsWidget({super.key, required this.certifications});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chứng chỉ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 12),
              if (certifications.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: certifications.length,
                  itemBuilder: (context, index) {
                    final cert = certifications[index] as Map<String, dynamic>;
                    // Determine image URL
                    String? imageUrl;
                    if (cert['image'] is String) {
                      imageUrl = cert['image'] as String;
                    } else if (cert['image'] is List) {
                      final imageList = cert['image'] as List<dynamic>;
                      imageUrl = imageList.isNotEmpty ? imageList[0] as String : null;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          height: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Certificate Image
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: imageUrl != null && imageUrl.isNotEmpty
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.broken_image,
                                        size: 30,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  )
                                      : Icon(
                                    Icons.image_not_supported,
                                    size: 30,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Certificate Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cert['name'] ?? 'Chứng chỉ không xác định',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Expanded(
                                        child: Text(
                                          cert['description'] ?? 'Không có mô tả',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                            letterSpacing: 0.2,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Kinh nghiệm: ${cert['experience'] ?? 0} năm',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          letterSpacing: 0.2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              else
                Text(
                  'Không có chứng chỉ nào',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: Colors.grey,
                    letterSpacing: 0.2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}