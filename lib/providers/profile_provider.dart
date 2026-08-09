import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/profile_image_service.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthService _auth = AuthService.instance;
  final ProfileImageService _profileImageService = ProfileImageService.instance;

  bool _isUploading = false;

  bool get isUploading => _isUploading;

  Future<bool> uploadProfileImage(String uid) async {
    try {
      _isUploading = true;
      notifyListeners();

      final imageUrl = await _profileImageService.pickAndUploadImage(uid);

      if (imageUrl == null) {
        _isUploading = false;
        notifyListeners();
        return false;
      }

      await _auth.updateProfileImage(uid, imageUrl);

      _isUploading = false;
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("PROFILE UPLOAD ERROR: $e");

      _isUploading = false;
      notifyListeners();

      return false;
    }
  }
}
