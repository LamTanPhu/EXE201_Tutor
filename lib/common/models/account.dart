class Account {
  final String? id;
  final String? fullName;
  final String? avatar;
  final String? email;
  final String? phone;
  final String? status;
  final String? role;
  final int? balance;

  Account({
    this.id,
    this.fullName,
    this.avatar,
    this.email,
    this.phone,
    this.status,
    this.role,
    this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String?,
      role: json['role'] as String?,
      balance: json['balance'] as int?,
    );
  }
}