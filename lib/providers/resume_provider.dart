import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/resume_model.dart';
import '../services/auth_service.dart';
import '../services/resume_service.dart';

class ResumeProvider extends ChangeNotifier {
  final ResumeService _resumeService = ResumeService.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> pickAndUploadResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result == null) return;

    final file = result.files.first;

    if (file.bytes == null) {
      throw Exception("Unable to read selected PDF.");
    }

    if (file.size > 5 * 1024 * 1024) {
      throw Exception("Resume size should be less than 5 MB.");
    }

    _setLoading(true);

    try {
      final userId = AuthService.instance.currentUser!.uid;

      await _resumeService.uploadResume(file, userId);
    } finally {
      _setLoading(false);
    }
  }

  Stream<ResumeModel?> getResume() {
    final userId = AuthService.instance.currentUser!.uid;

    return _resumeService.getResumeStream(userId);
  }

  Future<void> deleteResume(ResumeModel resume) async {
    _setLoading(true);

    try {
      await _resumeService.deleteResume(resume);
    } finally {
      _setLoading(false);
    }
  }
}
