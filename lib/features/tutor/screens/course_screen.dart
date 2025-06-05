import 'package:flutter/material.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/currency.dart';
import 'package:tutor/features/tutor/screens/course_creation_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final List<Course> _courses = [
    Course(
      name: 'Basic Math',
      description: 'An introductory course to arithmetic.',
      image: '',
      price: 19.99,
    ),
    Course(
      name: 'English for Beginners',
      description: 'Start learning English today!',
      image: '',
      price: 29.99,
    ),
  ];

  //navigate to create course screen
  void _goToCourseCreation() async {
    final newCourse = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => const CreateCourseScreen()),
    );
    //if success
    //back to list
    if (newCourse != null) {
      setState(() {
        _courses.add(newCourse);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Your Courses',
          style: TextStyle(color: AppColors.primary),
        ),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _goToCourseCreation,
          ),
        ],
      ),
      body:
          _courses.isEmpty
              ? const Center(child: Text('No courses created yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return Card(
                    elevation: 3,
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading:
                          course.image.isNotEmpty
                              ? Image.network(
                                course.image,
                                width: 40,
                                height: 20,
                                fit: BoxFit.fill,
                              )
                              : const Icon(Icons.book, color: AppColors.primary,),
                      title: Text(
                        course.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(course.description),
                      trailing: Text(
                        '${CurrencyUtils.formatVND(course.price)}',
                        //or use course.price.toStringAsFixed(2) if you don't have CurrencyUtils
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCourseCreation,
        icon: const Icon(Icons.add),
        label: const Text('New Course'),
      ),
    );
  }
}
