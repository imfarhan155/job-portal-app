import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/constants/firebase_constants.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // ================= SIGN UP =================

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = UserModel(
      uid: credential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      role: role,
      image: "",
      fcmToken: "",
    );

    await _firestore
        .collection(FirebaseConstants.users)
        .doc(user.uid)
        .set(user.toMap());

    return user;
  }

  // ================= LOGIN =================

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return getUserData(credential.user!.uid);
  }

  // ================= USER =================

  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore
        .collection(FirebaseConstants.users)
        .doc(uid)
        .get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!);
  }

  // ================= UPDATE PROFILE =================

  Future<void> updateProfile(UserModel user) async {
    await _firestore
        .collection(FirebaseConstants.users)
        .doc(user.uid)
        .update(user.toMap());
  }

  Future<void> updateProfileImage(String uid, String imageUrl) async {
    await _firestore.collection(FirebaseConstants.users).doc(uid).update({
      "image": imageUrl,
    });
  }

  Future<void> updateFcmToken(String uid, String token) async {
    await _firestore.collection(FirebaseConstants.users).doc(uid).update({
      "fcmToken": token,
    });
  }

  // ================= RESET PASSWORD =================

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    await _auth.signOut();
  }
}
