import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firebase_constants.dart';
import '../models/application_model.dart';
import '../models/job_model.dart';
import '../models/user_model.dart';

class AdminService {
  AdminService._();

  static final AdminService instance = AdminService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //================ USERS =================//

  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection(FirebaseConstants.users)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection(FirebaseConstants.users)
        .doc(user.uid)
        .update(user.toMap());
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection(FirebaseConstants.users).doc(uid).delete();
  }

  //================ JOBS =================//

  Stream<List<JobModel>> getJobs() {
    return _firestore
        .collection(FirebaseConstants.jobs)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => JobModel.fromMap(doc.data())).toList(),
        );
  }

  Future<void> updateJob(JobModel job) async {
    await _firestore
        .collection(FirebaseConstants.jobs)
        .doc(job.jobId)
        .update(job.toMap());
  }

  Future<void> deleteJob(String jobId) async {
    await _firestore.collection(FirebaseConstants.jobs).doc(jobId).delete();
  }

  //============= APPLICATIONS =============//

  Stream<List<ApplicationModel>> getApplications() {
    return _firestore
        .collection(FirebaseConstants.applications)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ApplicationModel.fromMap(doc.data()))
              .toList(),
        );
  }

  //============== COUNTS =================//

  Future<int> totalUsers() async {
    final snapshot = await _firestore.collection(FirebaseConstants.users).get();

    return snapshot.docs.length;
  }

  Future<int> totalEmployers() async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.users)
        .where("role", isEqualTo: "employer")
        .get();

    return snapshot.docs.length;
  }

  Future<int> totalJobs() async {
    final snapshot = await _firestore.collection(FirebaseConstants.jobs).get();

    return snapshot.docs.length;
  }

  Future<int> totalApplications() async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.applications)
        .get();

    return snapshot.docs.length;
  }

  Future<int> acceptedApplications() async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.applications)
        .where("status", isEqualTo: "Accepted")
        .get();

    return snapshot.docs.length;
  }

  Future<int> rejectedApplications() async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.applications)
        .where("status", isEqualTo: "Rejected")
        .get();

    return snapshot.docs.length;
  }

  Future<int> pendingApplications() async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.applications)
        .where("status", isEqualTo: "Pending")
        .get();

    return snapshot.docs.length;
  }
}
