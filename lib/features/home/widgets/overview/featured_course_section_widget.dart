import 'package:flutter/material.dart';
import 'package:tutor/features/home/widgets/home_grid_item_widget.dart';

class FeaturedCourseSectionWidget extends StatelessWidget {
  final dynamic course;
  final VoidCallback onTap;

  const FeaturedCourseSectionWidget({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Course',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        course == null
            ? const Center(
          child: Text(
            'No featured course available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        )
            : LayoutBuilder(
          builder: (context, constraints) {
            return HomeGridItemWidget(
              item: {
                'course': course['course'],
                'account': {'fullName': course['account']['fullName']},
              },
              isTeacherMode: false,
              onTap: onTap,
            );
          },
        ),
      ],
    );
  }
}