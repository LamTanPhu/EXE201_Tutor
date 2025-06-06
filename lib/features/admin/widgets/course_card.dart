import 'package:flutter/material.dart';
import 'package:tutor/common/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(course.image, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(course.name),
        subtitle: Text(course.description),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${course.price.toStringAsFixed(2)}'),
            Text(course.isActive == true ? '🟢 Active' : '🔴 Inactive'),
          ],
        ),
      ),
    );
  }
}
