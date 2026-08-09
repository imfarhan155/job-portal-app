import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/firebase_constants.dart';
import '../models/resume_model.dart';

class ResumeService {
  ResumeService._();

  static final ResumeService instance = ResumeService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ResumeModel?> getResume(String userId) async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.resumes)
        .where("userId", isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return ResumeModel.fromMap(snapshot.docs.first.data());
  }

  Stream<ResumeModel?> getResumeStream(String userId) {
    return _firestore
        .collection(FirebaseConstants.resumes)
        .where("userId", isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return null;
          }

          return ResumeModel.fromMap(snapshot.docs.first.data());
        });
  }

  Future<void> uploadResume(PlatformFile file, String userId) async {
    Uint8List? bytes;

    if (kIsWeb) {
      bytes = file.bytes;
    } else {
      if (file.path != null) {
        bytes = await File(file.path!).readAsBytes();
      }
    }

    if (bytes == null) {
      throw Exception("Please select a valid PDF.");
    }

    final existingResume = await getResume(userId);

    if (existingResume != null) {
      try {
        final oldPath = existingResume.fileUrl.split("/resumes/").last;

        await _supabase.storage.from("resumes").remove([oldPath]);

        await _firestore
            .collection(FirebaseConstants.resumes)
            .doc(existingResume.resumeId)
            .delete();
      } catch (_) {}
    }

    final resumeId = const Uuid().v4();

    final extension = path.extension(file.name);

    final storagePath = "$userId/$resumeId$extension";

    await _supabase.storage
        .from("resumes")
        .uploadBinary(
          storagePath,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: "application/pdf",
          ),
        );

    final url = _supabase.storage.from("resumes").getPublicUrl(storagePath);

    final resume = ResumeModel(
      resumeId: resumeId,
      userId: userId,
      fileName: file.name,
      fileUrl: url,
      fileSize: file.size,
      uploadedAt: DateTime.now(),
    );

    await _firestore
        .collection(FirebaseConstants.resumes)
        .doc(resumeId)
        .set(resume.toMap());
  }

  Future<void> deleteResume(ResumeModel resume) async {
    try {
      final storagePath = resume.fileUrl.split("/resumes/").last;

      await _supabase.storage.from("resumes").remove([storagePath]);
    } catch (_) {}

    await _firestore
        .collection(FirebaseConstants.resumes)
        .doc(resume.resumeId)
        .delete();
  }

  Future<String> downloadResume(String url, String fileName) async {
    if (kIsWeb) {
      return url;
    }

    final directory = await getTemporaryDirectory();

    final filePath = "${directory.path}/$fileName";

    await Dio().download(url, filePath);

    return filePath;
  }
}
