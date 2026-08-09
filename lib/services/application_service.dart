import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firebase_constants.dart';
import '../models/application_model.dart';
import 'notification_service.dart';

class ApplicationService {
  ApplicationService._();

  static final ApplicationService instance = ApplicationService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _applications =>
      _firestore.collection(FirebaseConstants.applications);

  // Apply Job
  Future<void> applyJob(ApplicationModel application) async {
    await _applications.doc(application.applicationId).set(application.toMap());
  }

  // Check if user already applied
  Future<bool> hasAlreadyApplied({
    required String jobId,
    required String userId,
  }) async {
    final snapshot = await _applications
        .where("jobId", isEqualTo: jobId)
        .where("userId", isEqualTo: userId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // Update Status
  Future<void> updateStatus(String applicationId, String status) async {
    final applicationDoc = await _applications.doc(applicationId).get();

    if (!applicationDoc.exists) return;

    final data = applicationDoc.data() as Map<String, dynamic>;

    final userId = data["userId"];

    await _applications.doc(applicationId).update({"status": status});

    if (status.toLowerCase() == "accepted") {
      await NotificationService.instance.sendNotification(
        userId: userId,
        title: "Application Accepted",
        message: "Your job application has been accepted by employer.",
      );
    }

    if (status.toLowerCase() == "rejected") {
      await NotificationService.instance.sendNotification(
        userId: userId,
        title: "Application Rejected",
        message: "Your job application has been rejected by employer.",
      );
    }
  }

  // Delete Application
  Future<void> deleteApplication(String applicationId) async {
    await _applications.doc(applicationId).delete();
  }

  // Get All Applications
  Stream<List<ApplicationModel>> getApplications() {
    return _applications.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ApplicationModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get User Applications
  Stream<List<ApplicationModel>> getUserApplications(String userId) {
    return _applications.where("userId", isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return ApplicationModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get Applications of Specific Job
  Stream<List<ApplicationModel>> getJobApplications(String jobId) {
    return _applications.where("jobId", isEqualTo: jobId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return ApplicationModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
