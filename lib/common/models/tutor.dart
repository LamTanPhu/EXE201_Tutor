import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/models/certification.dart';

class Tutor {
  final Account account;
  final List<Certification> certifications;

  Tutor({required this.account, required this.certifications});

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      account: Account.fromJson(json['account']),
      certifications:
          (json['certifications'] as List)
              .map((certJson) => Certification.fromJson(certJson))
              .toList(),
    );
  }
}
