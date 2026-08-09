import 'package:flutter/material.dart';

import '../models/application_model.dart';
import '../services/application_service.dart';

class ApplicationProvider extends ChangeNotifier {
  final ApplicationService _service = ApplicationService.instance;

  // Get all applications
  Stream<List<ApplicationModel>> getApplications() {
    return _service.getApplications();
  }

  // Apply for a job
  Future<void> apply(ApplicationModel application) async {
    await _service.applyJob(application);
    notifyListeners();
  }

  // Update application status
  Future<void> updateStatus(String id, String status) async {
    await _service.updateStatus(id, status);
    notifyListeners();
  }

  // Delete application
  Future<void> deleteApplication(String applicationId) async {
    await _service.deleteApplication(applicationId);
    notifyListeners();
  }

  // Get applications of a specific user
  Stream<List<ApplicationModel>> getUserApplications(String userId) {
    return _service.getUserApplications(userId);
  }

  // Get applications of a specific job
  Stream<List<ApplicationModel>> getJobApplications(String jobId) {
    return _service.getJobApplications(jobId);
  }

  // Check if the user has already applied
  Future<bool> hasAlreadyApplied({
    required String jobId,
    required String userId,
  }) {
    return _service.hasAlreadyApplied(jobId: jobId, userId: userId);
  }
}
