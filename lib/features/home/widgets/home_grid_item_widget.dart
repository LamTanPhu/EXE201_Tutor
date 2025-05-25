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
      opacity: const AlwaysStoppedAnimation(1.0), // Fade animation placeholder
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isTeacherMode
                                ? [Colors.blue[300]!, Colors.blue[500]!]
                                : [Colors.purple[300]!, Colors.purple[500]!],
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
                                  size: 40, color: Colors.white)),
                        )
                            : const Center(
                            child: Icon(Icons.person,
                                size: 40, color: Colors.white))
                            : item['course']['image'] != null
                            ? Image.network(
                          item['course']['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Center(
                              child: Icon(Icons.school,
                                  size: 40, color: Colors.white)),
                        )
                            : const Center(
                            child: Icon(Icons.school,
                                size: 40, color: Colors.white)),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 12),
                              SizedBox(width: 2),
                              Text(
                                '4.8',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isTeacherMode
                            ? '${item['account']['role'] ?? 'Teacher'} • ${_getStatusText(item['account']['status'])}'
                            : 'By ${item['account']['fullName'] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isTeacherMode
                              ? _getStatusColor(item['account']['status'])
                              : Colors.grey[600],
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      if (!isTeacherMode) ...[
                        Text(
                          '${item['course']['price'] ?? 0} VND',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ] else ...[
                        if (item['certifications']?.isNotEmpty ?? false) ...[
                          Text(
                            '${item['certifications'][0]['experience'] ?? 0} years exp.',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
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