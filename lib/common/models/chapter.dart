
class Chapter {
  final String id;
  final String title;
  final String? courseId;
  Chapter({required this.id, required this.title, this.courseId});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['_id'],
      title: json['title'],
      courseId: json['courseId'] as String?,
    );
  }
}
