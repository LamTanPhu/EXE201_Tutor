class TutorProfile {
  final String fullName;
  final String email;
  final String phone;
  final String avatar;
  final double balance;

  TutorProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.balance,
  });

  factory TutorProfile.fromJson(Map<String, dynamic> json) {
    return TutorProfile(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}
