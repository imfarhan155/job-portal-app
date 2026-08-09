import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/firebase_constants.dart';
import '../models/notification_model.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _notifications =>
      _firestore.collection(FirebaseConstants.notifications);

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
  }) async {
    final notificationId = const Uuid().v4();

    final notification = NotificationModel(
      notificationId: notificationId,
      userId: userId,
      title: title,
      message: message,
      isRead: false,
      createdAt: DateTime.now(),
    );

    await _notifications.doc(notificationId).set(notification.toMap());

    print("Notification Sent To: $userId");
  }

  Stream<List<NotificationModel>> getNotifications(String userId) {
    print("========== FIRESTORE QUERY ==========");
    print("Query UserId: $userId");

    return _notifications
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
          print("Firestore Docs: ${snapshot.docs.length}");

          for (final doc in snapshot.docs) {
            print(doc.data());
          }

          print("====================================");

          return snapshot.docs
              .map(
                (doc) => NotificationModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();
        });
  }

  Future<void> markAsRead(String notificationId) async {
    print("Mark As Read => $notificationId");

    await _notifications.doc(notificationId).update({"isRead": true});
  }

  Future<void> deleteNotification(String notificationId) async {
    print("Delete Notification => $notificationId");

    await _notifications.doc(notificationId).delete();
  }
}
