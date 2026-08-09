import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firebase_constants.dart';
import '../models/job_model.dart';

class JobService {
  JobService._();

  static final JobService instance = JobService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _jobs =>
      _firestore.collection(FirebaseConstants.jobs);

  Future<void> addJob(JobModel job) async {
    await _jobs.doc(job.jobId).set(job.toMap());
  }

  Future<void> updateJob(JobModel job) async {
    await _jobs.doc(job.jobId).update(job.toMap());
  }

  Future<void> deleteJob(String jobId) async {
    await _jobs.doc(jobId).delete();
  }

  Stream<List<JobModel>> getJobs() {
    return _jobs.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => JobModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  Stream<List<JobModel>> getEmployerJobs(String employerId) {
    return _jobs
        .where("employerId", isEqualTo: employerId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => JobModel.fromMap(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
