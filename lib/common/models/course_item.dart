import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/models/course.dart';

class CourseItem {
  final Course course;
  final Account account;
  final List<Certification> certifications;

  CourseItem({
    required this.course,
    required this.account,
    required this.certifications,
  });

  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      course: Course.fromJson(json['course'] ?? {}),
      account: Account.fromJson(json['account'] ?? {}),
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((certJson) => Certification.fromJson(certJson))
              .toList() ??
          [],
    );
  }
}