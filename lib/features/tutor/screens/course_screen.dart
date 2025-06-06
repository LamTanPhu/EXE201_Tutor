import 'package:flutter/material.dart';
import 'package:tutor/common/models/Content.dart';
import 'package:tutor/common/models/chapter.dart';
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
      price: 1000000.00,
    ),
    Course(
      name: 'English for Beginners',
      description: 'Start learning English today!',
      image: '',
      price: 3000000.00,
    ),
  ];

  String _searchText = '';

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

void _showCourseDetails(Course course) async {
  //fake data for chapters and contents
  final chapters = [
    Chapter(id: '1', title: 'Introduction', courseId: course.id),
    Chapter(id: '2', title: 'Chapter 1: Basic Concept', courseId: course.id),
  ];

  List<Content> fakeContents(String chapterId) {
    if (chapterId == '1') {
      return [
        Content(id: 'c1', title: 'Welcome', description: 'Introduction about course', chapterId: chapterId),
      ];
    } else {
      return [
        Content(id: 'c2', title: 'Lesson 1', description: 'Content 1', chapterId: chapterId),
        Content(id: 'c3', title: 'Lesson 2', description: 'Content 2', chapterId: chapterId),
      ];
    }
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(course.name),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...chapters.map((chapter) => ListTile(
              title: Text(chapter.title),
              onTap: () async {
                final contents = fakeContents(chapter.id);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(chapter.title),
                    content: SizedBox(
                      width: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...contents.map((content) => ListTile(
                            title: Text(content.title),
                            subtitle: Text(content.description),
                          )),
                          ElevatedButton(
                            onPressed: () {
                            },
                            child: const Text('Add content'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Add chapter'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
   List<Course> get _filteredCourses {
    if (_searchText.isEmpty) return _courses;
    return _courses
        .where((c) =>
            c.name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: _filteredCourses.isEmpty
                ? const Center(child: Text('No courses found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return Card(
                        elevation: 3,
                        color: AppColors.card,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () => _showCourseDetails(course),
                          leading: course.image.isNotEmpty
                              ? Image.network(
                                  course.image,
                                  width: 40,
                                  height: 20,
                                  fit: BoxFit.fill,
                                )
                              : const Icon(Icons.book, color: AppColors.primary),
                          title: Text(
                            course.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(course.description),
                          trailing: Text(
                            CurrencyUtils.formatVND(course.price),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCourseCreation,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }
}