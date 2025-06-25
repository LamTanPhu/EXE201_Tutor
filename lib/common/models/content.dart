class Content {
  final String id;
  final String title;
  final String description;
  final String? chapterId;
  Content({required this.id, required this.title, required this.description, this.chapterId});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      chapterId: json['chapterId'] as String?,
    );
  }
}