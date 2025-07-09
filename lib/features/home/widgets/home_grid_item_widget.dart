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
    return FadeTransition(
      opacity: const AlwaysStoppedAnimation(1.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isTeacherMode
                                ? [Color(0xFF4A90E2), Color(0xFF50E3C2)]
                                : [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: isTeacherMode
                            ? (item['account']['avatar'] != null &&
                            item['account']['avatar'].isNotEmpty)
                            ? Image.network(
                          item['account']['avatar'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Center(
                              child: Icon(Icons.person,
                                  size: 50, color: Colors.white)),
                        )
                            : const Center(
                            child: Icon(Icons.person,
                                size: 50, color: Colors.white))
                            : item['course']['image'] != null
                            ? Image.network(
                          item['course']['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Center(
                              child: Icon(Icons.school,
                                  size: 50, color: Colors.white)),
                        )
                            : const Center(
                            child: Icon(Icons.school,
                                size: 50, color: Colors.white)),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                '4.8',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTeacherMode
                            ? item['account']['fullName'] ?? 'Unknown Tutor'
                            : item['course']['name'] ?? 'Unknown Course',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isTeacherMode
                            ? '${item['account']['role'] ?? 'Teacher'} • ${_getStatusText(item['account']['status'])}'
                            : 'By ${item['account']['fullName'] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isTeacherMode
                              ? _getStatusColor(item['account']['status'])
                              : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      if (!isTeacherMode) ...[
                        Text(
                          '${item['course']['price'] ?? 0} VND',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2ECC71),
                          ),
                        ),
                      ] else ...[
                        if (item['certifications']?.isNotEmpty ?? false) ...[
                          Text(
                            '${item['certifications'][0]['experience'] ?? 0} years exp.',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}