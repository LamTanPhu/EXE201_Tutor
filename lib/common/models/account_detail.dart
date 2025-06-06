import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/models/course.dart';

class AccountDetail {
  final Account account;
  final List<Certification> certifications;
  final List<Course> courses;

  AccountDetail({
    required this.account,
    required this.certifications,
    required this.courses,
  });

  factory AccountDetail.fromJson(Map<String, dynamic> json) {
    return AccountDetail(
      account: Account.fromJson(json['data']['account']),
      certifications:
          (json['data']['certifications'] as List)
              .map((e) => Certification.fromJson(e))
              .toList(),
      courses:
          (json['data']['courses'] as List)
              .map((e) => Course.fromJson(e))
              .toList(),
    );
  }
}
