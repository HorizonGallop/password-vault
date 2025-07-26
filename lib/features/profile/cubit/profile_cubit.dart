import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_state.dart';
import 'package:pswrd_vault/core/models/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// ✅ تحميل بيانات المستخدم
  Future<void> loadUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const ProfileError("User not logged in"));
      return;
    }

    emit(ProfileLoading());
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        emit(const ProfileError("User profile not found"));
        return;
      }

      final data = doc.data() ?? {};

      final user = UserModel.fromMap(data);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError("Failed to load profile: $e"));
    }
  }

  /// ✅ تسجيل الخروج
  Future<void> signOut() async {
    emit(ProfileLoading());
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      await _secureStorage.deleteAll();
      emit(SignedOut());
    } catch (e) {
      emit(ProfileError("Failed to sign out: $e"));
    }
  }

  /// ✅ حذف الحساب نهائيًا
  Future<void> deleteAccountNow(String inputMasterPassword) async {
    final uid = _auth.currentUser?.uid;
    final user = _auth.currentUser;

    if (uid == null || user == null) {
      emit(const ProfileError("User not logged in"));
      return;
    }

    emit(ProfileLoading());

    try {
      // 1. جلب بيانات المستخدم للتحقق من الماسترباسوورد
      final userDocRef = _firestore.collection('users').doc(uid);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        emit(const ProfileError("User profile not found"));
        return;
      }

      final data = userDoc.data()!;
      final salt = data['salt'] as String? ?? '';
      final storedHash = data['masterPasswordHash'] as String? ?? '';

      print("Salt from Firestore: $salt");
      print("Stored hash from Firestore: $storedHash");

      final inputHash = _hashPassword(inputMasterPassword, salt);

      print("Computed hash from input: $inputHash");

      if (inputHash != storedHash) {
        emit(const ProfileError("Master password is incorrect"));
        return;
      }

      // 2. إعادة توثيق المستخدم باستخدام جوجل
      print("Starting Google sign-in for reauthentication...");
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(const ProfileError("Google sign-in cancelled"));
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.reauthenticateWithCredential(credential);
      print("Reauthentication succeeded");

      // 3. حذف بيانات Firestore المرتبطة بالمستخدم (batch)
      final batch = _firestore.batch();
      batch.delete(userDocRef);

      final userRelatedDocs = await _firestore
          .collection('userData')
          .where('userId', isEqualTo: uid)
          .get();

      for (var doc in userRelatedDocs.docs) {
        batch.delete(doc.reference);
      }

      // أضف هنا حذف مجموعات أخرى مرتبطة بالمستخدم لو موجودة

      await batch.commit();
      print("Firestore user data deleted");

      // 4. حذف المستخدم من Firebase Authentication
      await user.delete();
      print("Firebase user deleted");

      // 5. حذف البيانات المحلية الآمنة
      await _secureStorage.deleteAll();
      print("Local secure storage cleared");

      emit(AccountDeleted());
    } catch (e, stacktrace) {
      print("Error during deleteAccountNow: $e");
      print(stacktrace);
      emit(ProfileError("Failed to delete account: $e"));
    }
  }

  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
