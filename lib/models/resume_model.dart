class ResumeModel {
  final String resumeId;
  final String userId;
  final String fileName;
  final String fileUrl;
  final int fileSize;
  final DateTime uploadedAt;

  const ResumeModel({
    required this.resumeId,
    required this.userId,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.uploadedAt,
  });

  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    return ResumeModel(
      resumeId: map["resumeId"] ?? "",
      userId: map["userId"] ?? "",
      fileName: map["fileName"] ?? "",
      fileUrl: map["fileUrl"] ?? "",
      fileSize: map["fileSize"] ?? 0,
      uploadedAt: DateTime.parse(map["uploadedAt"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "resumeId": resumeId,
      "userId": userId,
      "fileName": fileName,
      "fileUrl": fileUrl,
      "fileSize": fileSize,
      "uploadedAt": uploadedAt.toIso8601String(),
    };
  }
}
