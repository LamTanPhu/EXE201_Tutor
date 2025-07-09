import 'package:flutter/material.dart';

class HomeGridItemWidget extends StatelessWidget {
  final dynamic item;
  final bool isTeacherMode;
  final VoidCallback onTap;

  const HomeGridItemWidget({
    super.key,
    required this.item,
    required this.isTeacherMode,
    required this.onTap,
  });

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return 'Available';
      case 'inactive':
        return 'Unavailable';
      case 'busy':
        return 'Busy';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'busy':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final fontScaleFactor = screenWidth / 400; // Base scale for 400px width
    final baseFontSize = 16.0;
    final basePadding = 12.0;
    final baseIconSize = 50.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16 * fontScaleFactor),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16 * fontScaleFactor),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Allow card to size to content
              children: [
                // Image Section
                AspectRatio(
                  aspectRatio: 16 / 9, // Standard aspect ratio for images
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16 * fontScaleFactor)),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isTeacherMode
                                  ? [const Color(0xFF4A90E2), const Color(0xFF50E3C2)]
                                  : [const Color(0xFF9B59B6), const Color(0xFF8E44AD)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: isTeacherMode
                              ? (item['account']['avatar'] != null &&
                              item['account']['avatar'].isNotEmpty)
                              ? Image.network(
                            item['account']['avatar'],
                            fit: BoxFit.cover, // Corrected from coverCrop to cover
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Icon(
                                Icons.person,
                                size: baseIconSize * fontScaleFactor,
                                color: Colors.white,
                              ),
                            ),
                          )
                              : Center(
                            child: Icon(
                              Icons.person,
                              size: baseIconSize * fontScaleFactor,
                              color: Colors.white,
                            ),
                          )
                              : (item['course']['image'] != null &&
                              item['course']['image'].isNotEmpty)
                              ? Image.network(
                            item['course']['image'],
                            fit: BoxFit.cover, // Corrected from coverCrop to cover
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Icon(
                                Icons.school,
                                size: baseIconSize * fontScaleFactor,
                                color: Colors.white,
                              ),
                            ),
                          )
                              : Center(
                            child: Icon(
                              Icons.school,
                              size: baseIconSize * fontScaleFactor,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8 * fontScaleFactor,
                          right: 8 * fontScaleFactor,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8 * fontScaleFactor,
                              vertical: 4 * fontScaleFactor,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10 * fontScaleFactor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 14 * fontScaleFactor,
                                ),
                                SizedBox(width: 4 * fontScaleFactor),
                                Text(
                                  '4.8',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12 * fontScaleFactor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Content Section
                Padding(
                  padding: EdgeInsets.all(basePadding * fontScaleFactor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isTeacherMode
                            ? item['account']['fullName'] ?? 'Unknown Tutor'
                            : item['course']['name'] ?? 'Unknown Course',
                        style: TextStyle(
                          fontSize: baseFontSize * fontScaleFactor,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8 * fontScaleFactor),
                      Text(
                        isTeacherMode
                            ? '${item['account']['role'] ?? 'Teacher'} • ${_getStatusText(item['account']['status'])}'
                            : 'By ${item['account']['fullName'] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: (baseFontSize - 2) * fontScaleFactor,
                          color: isTeacherMode
                              ? _getStatusColor(item['account']['status'])
                              : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8 * fontScaleFactor),
                      if (!isTeacherMode) ...[
                        Text(
                          '${item['course']['price'] ?? 0} VND',
                          style: TextStyle(
                            fontSize: baseFontSize * fontScaleFactor,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2ECC71),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else ...[
                        if (item['certifications']?.isNotEmpty ?? false) ...[
                          Text(
                            '${item['certifications'][0]['experience'] ?? 0} years exp.',
                            style: TextStyle(
                              fontSize: (baseFontSize - 2) * fontScaleFactor,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4A90E2),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}