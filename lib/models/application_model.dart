class ApplicationModel {
  final String applicationId;
  final String jobId;
  final String jobTitle;
  final String companyName;

  final String userId;
  final String applicantName;
  final String applicantEmail;
  final String applicantPhone;

  // Resume
  final String resumeUrl;
  final String resumeName;

  final String status;
  final DateTime appliedDate;

  const ApplicationModel({
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.userId,
    required this.applicantName,
    required this.applicantEmail,
    required this.applicantPhone,
    required this.resumeUrl,
    required this.resumeName,
    required this.status,
    required this.appliedDate,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      applicationId: map["applicationId"] ?? "",
      jobId: map["jobId"] ?? "",
      jobTitle: map["jobTitle"] ?? "",
      companyName: map["companyName"] ?? "",
      userId: map["userId"] ?? "",
      applicantName: map["applicantName"] ?? "",
      applicantEmail: map["applicantEmail"] ?? "",
      applicantPhone: map["applicantPhone"] ?? "",
      resumeUrl: map["resumeUrl"] ?? "",
      resumeName: map["resumeName"] ?? "",
      status: map["status"] ?? "Pending",
      appliedDate: map["appliedDate"] != null
          ? DateTime.parse(map["appliedDate"])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "applicationId": applicationId,
      "jobId": jobId,
      "jobTitle": jobTitle,
      "companyName": companyName,
      "userId": userId,
      "applicantName": applicantName,
      "applicantEmail": applicantEmail,
      "applicantPhone": applicantPhone,
      "resumeUrl": resumeUrl,
      "resumeName": resumeName,
      "status": status,
      "appliedDate": appliedDate.toIso8601String(),
    };
  }

  ApplicationModel copyWith({
    String? applicationId,
    String? jobId,
    String? jobTitle,
    String? companyName,
    String? userId,
    String? applicantName,
    String? applicantEmail,
    String? applicantPhone,
    String? resumeUrl,
    String? resumeName,
    String? status,
    DateTime? appliedDate,
  }) {
    return ApplicationModel(
      applicationId: applicationId ?? this.applicationId,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      userId: userId ?? this.userId,
      applicantName: applicantName ?? this.applicantName,
      applicantEmail: applicantEmail ?? this.applicantEmail,
      applicantPhone: applicantPhone ?? this.applicantPhone,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      resumeName: resumeName ?? this.resumeName,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
    );
  }
}
