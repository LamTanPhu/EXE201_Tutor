class RevenueData {
final List<MonthlyRevenue> revenue;

  RevenueData({required this.revenue});

  factory RevenueData.fromJson(dynamic json) {
    return RevenueData(
      revenue: (json as List<dynamic>)
          .map((e) => MonthlyRevenue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

}

class MonthlyRevenue{
  final int? month;
  final double? revenue;

  MonthlyRevenue({this.month, this.revenue});

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenue(
      month: json['month'] as int?,
      revenue: (json['revenue'] as num?)?.toDouble(),
    );
  }
}

class StatusData {
  final Map<String, int> statuses;

  StatusData({required this.statuses});

  factory StatusData.fromJson(dynamic json) {
    return StatusData(
      statuses: (json as Map<String, dynamic>).map((key, value) => MapEntry(key, value as int)),
    );
  }

  int get active => statuses['Active'] ?? 0;
  int get inactive => statuses['InActive'] ?? 0;

    @override
  String toString() => 'StatusData($statuses)';
}

class TopAccount {
  final String? accountId;
  final String? fullName;
  final String? email;
  final int? completedCourses;

  TopAccount({this.accountId, this.fullName, this.email, this.completedCourses});

  factory TopAccount.fromJson(dynamic json) {
    return TopAccount(
      accountId: json['accountId'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      completedCourses: json['completedCourses'] as int?,
    );
  }
}


class DashboardCombinedData {
  final StatusData accountStatus;
  final StatusData courseStatus;

  DashboardCombinedData({
    required this.accountStatus,
    required this.courseStatus,
  });
}
