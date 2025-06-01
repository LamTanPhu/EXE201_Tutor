import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CourseHeader extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseHeader({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Course Image
        course['image'] != null
            ? Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: course['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 200,
                  color: Colors.grey,
                ),
              ),
              errorWidget: (context, url, error) => Image.network(
                'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
            : const SizedBox.shrink(),
        const SizedBox(height: 16),
        // Course Title
        Text(
          course['name'] ?? 'Unknown Course',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        // Price and Instructor
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Price: ${course['price'] ?? 'N/A'} VND',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'By ${course['instructor'] ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}