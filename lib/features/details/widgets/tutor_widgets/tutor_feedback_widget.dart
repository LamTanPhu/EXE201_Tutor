import 'package:flutter/material.dart';

class TutorFeedbackWidget extends StatelessWidget {
  const TutorFeedbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Feedback',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No feedback available yet.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          // TODO: Integrate ApiService.getCourseFeedback to display feedback
        ],
      ),
    );
  }
}