import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_state.dart';
import 'package:pswrd_vault/core/models/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker.createInstance();

  /// ✅ فحص الاتصال وإرجاع النتيجة
  Future<bool> checkConnection() async {
    final hasConnection = await _connectionChecker.hasConnection;
    if (!hasConnection) {
      emit(const NoInternetConnection());
    }
    return hasConnection;
  }

  /// ✅ تحميل بيانات المستخدم
  Future<void> loadUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const ProfileError("User not logged in"));
      return;
    }

    emit(ProfileLoading());

    try {
      if (!await checkConnection()) return;

      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        emit(const ProfileError("User profile not found"));
        return;
      }

      final user = UserModel.fromMap(doc.data() ?? {});
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError("Failed to load profile: $e"));
    }
  }

  /// ✅ تسجيل الخروج
  Future<void> signOut() async {
    emit(ProfileLoading());

    try {
      if (!await checkConnection()) return;

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
      if (!await checkConnection()) return;

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

      final inputHash = _hashPassword(inputMasterPassword, salt);

      if (inputHash != storedHash) {
        emit(const ProfileError("Master password is incorrect"));
        return;
      }

      // 2. إعادة توثيق المستخدم باستخدام جوجل
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

      // 3. حذف بيانات Firestore
      final batch = _firestore.batch();
      batch.delete(userDocRef);

      final userRelatedDocs = await _firestore
          .collection('userData')
          .where('userId', isEqualTo: uid)
          .get();

      for (var doc in userRelatedDocs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // 4. حذف المستخدم من Firebase Auth
      await user.delete();

      // 5. حذف البيانات المحلية
      await _secureStorage.deleteAll();

      emit(AccountDeleted());
    } catch (e, stacktrace) {
      print("Error during deleteAccountNow: $e");
      print(stacktrace);
      emit(ProfileError("Failed to delete account: $e"));
    }
  }

  /// ✅ تحقق من الماستر باسوورد بدون حذف الحساب
  Future<bool> verifyMasterPassword(String inputPassword) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    try {
      if (!await checkConnection()) return false;

      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) return false;

      final data = userDoc.data()!;
      final salt = data['salt'] as String? ?? '';
      final storedHash = data['masterPasswordHash'] as String? ?? '';

      final inputHash = _hashPassword(inputPassword, salt);
      return inputHash == storedHash;
    } catch (_) {
      return false;
    }
  }

  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
