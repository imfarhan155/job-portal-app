import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      _setLoading(true);

      _user = await _authService.login(email: email, password: password);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      _setLoading(true);

      _user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
      );

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    if (_authService.currentUser == null) return;

    _user = await _authService.getUserData(_authService.currentUser!.uid);

    notifyListeners();
  }

  Future<void> refreshUser() async {
    if (_authService.currentUser == null) return;

    _user = await _authService.getUserData(_authService.currentUser!.uid);

    notifyListeners();
  }
}
