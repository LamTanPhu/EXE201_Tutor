class Certification {
  final String? id;
  final String? name;
  final String? description;
  final List<String> image;
  final int? experience;
  final bool? isChecked;
  final bool? isCanTeach;
  final String? createBy;

  Certification({
    this.id,
    this.name,
    this.description,
    required this.image, // Giữ required vì List không null
    this.experience,
    this.isChecked,
    this.isCanTeach,
    this.createBy,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: List<String>.from(json['image'] ?? []),
      experience: json['experience'] as int?,
      isChecked: json['isChecked'] as bool?,
      isCanTeach: json['isCanTeach'] as bool?,
      createBy: json['createBy'] as String?,
    );
  }
}