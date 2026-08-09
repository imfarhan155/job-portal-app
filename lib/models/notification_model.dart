class NotificationModel {
  final String notificationId;
  final String userId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map["notificationId"] ?? "",
      userId: map["userId"] ?? "",
      title: map["title"] ?? "",
      message: map["message"] ?? "",
      isRead: map["isRead"] ?? false,
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "notificationId": notificationId,
      "userId": userId,
      "title": title,
      "message": message,
      "isRead": isRead,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    String? title,
    String? message,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
