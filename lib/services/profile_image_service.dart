import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileImageService {
  ProfileImageService._();

  static final ProfileImageService instance = ProfileImageService._();

  final _picker = ImagePicker();
  final _supabase = Supabase.instance.client;

  Future<String?> pickAndUploadImage(String uid) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return null;

      final file = File(image.path);

      final extension = path.extension(image.path);

      final fileName =
          "${uid}_${DateTime.now().millisecondsSinceEpoch}$extension";

      await _supabase.storage
          .from("profile-images")
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      final url = _supabase.storage
          .from("profile-images")
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
