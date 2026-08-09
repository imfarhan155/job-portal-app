import 'package:flutter/material.dart';

import '../models/job_model.dart';
import '../services/job_service.dart';

class JobProvider extends ChangeNotifier {
  final JobService _jobService = JobService.instance;

  List<JobModel> _jobs = [];

  List<JobModel> get jobs => _jobs;

  // ================= GET ALL JOBS =================

  Stream<List<JobModel>> getJobs() {
    return _jobService.getJobs();
  }

  // ================= GET EMPLOYER JOBS =================

  Stream<List<JobModel>> getEmployerJobs(String employerId) {
    return _jobService.getEmployerJobs(employerId);
  }

  // ================= ADD JOB =================

  Future<void> addJob(JobModel job) async {
    await _jobService.addJob(job);
    notifyListeners();
  }

  // ================= UPDATE JOB =================

  Future<void> updateJob(JobModel job) async {
    await _jobService.updateJob(job);
    notifyListeners();
  }

  // ================= DELETE JOB =================

  Future<void> deleteJob(String id) async {
    await _jobService.deleteJob(id);
    notifyListeners();
  }
}
