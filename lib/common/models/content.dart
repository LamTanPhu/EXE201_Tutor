class Content {
  final String id;
  final String chapterId;
  final String contentDescription;
  final String? createdBy; // chỉ lấy _id của createdBy
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Content({
    required this.id,
    required this.chapterId,
    required this.contentDescription,
    this.createdBy,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['_id'] as String,
      chapterId: json['chapterId'] as String,
      contentDescription: json['contentDescription'] as String,
      createdBy: json['createdBy'] is Map<String, dynamic>
          ? json['createdBy']['_id'] as String?
          : json['createdBy'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}