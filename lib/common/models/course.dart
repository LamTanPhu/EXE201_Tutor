class Course {
  final String id;
  final String? name;
  final String? description;
  final String? image;
  final double price;
  final bool? isActive;
  final String? createdBy;
  final DateTime? createdAt;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.isActive,
    this.createdBy,
    this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      createdBy: json['createdBy'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'createdBy': createdBy,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
