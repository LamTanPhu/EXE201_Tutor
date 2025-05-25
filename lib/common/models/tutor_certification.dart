class TutorCertification {
  final String tutorName;
  final String email;
  final String phone;
  final String certName;
  final String description;
  final String imageUrl;
  final int experience;
  final bool isChecked;
  final bool isCanTeach;

  TutorCertification({
    required this.tutorName,
    required this.email,
    required this.phone,
    required this.certName,
    required this.description,
    required this.imageUrl,
    required this.experience,
    required this.isChecked,
    required this.isCanTeach,
  });

  factory TutorCertification.fromJson(
    Map<String, dynamic> tutor,
    Map<String, dynamic> cert,
  ) {
    return TutorCertification(
      tutorName: tutor['account']['fullName'],
      email: tutor['account']['email'],
      phone: tutor['account']['phone'],
      certName: cert['name'],
      description: cert['description'],
      imageUrl: (cert['image'] as List).isNotEmpty ? cert['image'][0] : '',
      experience: cert['experience'],
      isChecked: cert['isChecked'],
      isCanTeach: cert['isCanTeach'],
    );
  }

  List<TutorCertification> extractPendingCertifications(
    Map<String, dynamic> json,
  ) {
    final List<TutorCertification> pendingList = [];

    final tutors = json['data']['tutors'] as List<dynamic>;
    for (var tutor in tutors) {
      final certs = tutor['certifications'] as List<dynamic>;
      for (var cert in certs) {
        if (cert['isChecked'] == false) {
          pendingList.add(TutorCertification.fromJson(tutor, cert));
        }
      }
    }

    return pendingList;
  }
}
