import 'package:flutter/material.dart';

import '../models/application_model.dart';
import '../models/job_model.dart';
import '../models/user_model.dart';
import '../services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int totalUsers = 0;
  int totalEmployers = 0;
  int totalJobs = 0;
  int totalApplications = 0;
  int acceptedApplications = 0;
  int rejectedApplications = 0;
  int pendingApplications = 0;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Stream<List<UserModel>> getUsers() {
    return _adminService.getUsers();
  }

  Stream<List<JobModel>> getJobs() {
    return _adminService.getJobs();
  }

  Stream<List<ApplicationModel>> getApplications() {
    return _adminService.getApplications();
  }

  //================ USERS =================//

  Future<void> deleteUser(String uid) async {
    _setLoading(true);

    try {
      await _adminService.deleteUser(uid);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUser(UserModel user) async {
    _setLoading(true);

    try {
      await _adminService.updateUser(user);
    } finally {
      _setLoading(false);
    }
  }

  //================ JOBS =================//

  Future<void> deleteJob(String jobId) async {
    _setLoading(true);

    try {
      await _adminService.deleteJob(jobId);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateJob(JobModel job) async {
    _setLoading(true);

    try {
      await _adminService.updateJob(job);
    } finally {
      _setLoading(false);
    }
  }

  //============== STATISTICS =================//

  Future<void> loadStatistics() async {
    _setLoading(true);

    try {
      totalUsers = await _adminService.totalUsers();

      totalEmployers = await _adminService.totalEmployers();

      totalJobs = await _adminService.totalJobs();

      totalApplications = await _adminService.totalApplications();

      acceptedApplications = await _adminService.acceptedApplications();

      rejectedApplications = await _adminService.rejectedApplications();

      pendingApplications = await _adminService.pendingApplications();

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }
}
