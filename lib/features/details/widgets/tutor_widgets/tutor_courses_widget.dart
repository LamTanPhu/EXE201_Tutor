import 'package:flutter/material.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/gradient_button_widget.dart';

class TutorCoursesWidget extends StatelessWidget {
  final List<dynamic> courses;

  const TutorCoursesWidget({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Courses',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 12),
              if (courses.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Course Image
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: course['image'] != null && course['image'].isNotEmpty
                                ? Image.network(
                              course['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.broken_image,
                                size: 30,
                                color: Colors.grey[400],
                              ),
                            )
                                : Icon(
                              Icons.image_not_supported,
                              size: 30,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Course Details
                          Expanded(
                            child: Text(
                              course['name'] ?? 'Unnamed Course',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${course['price']?.toString() ?? '0'}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              else
                const Text(
                  'No courses available',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    letterSpacing: 0.2,
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: GradientButtonWidget(
                  text: 'Contact For Details',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}