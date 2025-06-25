class Course {
  final String id;
  final String name;
  final String description;
  final String image;
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
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      createdBy: json['createdBy'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(
                json['createdAt'] as String,
              ) // Sử dụng tryParse để xử lý lỗi định dạng
              : null,
    );
  }
}
