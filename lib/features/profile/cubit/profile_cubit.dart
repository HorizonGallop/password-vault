import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_state.dart';

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
      emit(ProfileLoaded(data));
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

  /// ✅ جدولة حذف الحساب بعد 3 أيام
  Future<void> scheduleAccountDeletion() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const ProfileError("User not logged in"));
      return;
    }

    emit(ProfileLoading());
    try {
      final deletionDate = DateTime.now().add(const Duration(days: 3));
      await _firestore.collection('users').doc(uid).update({
        'deletionScheduled': true,
        'deletionDate': deletionDate.toIso8601String(),
      });

      emit(DeletionScheduled(deletionDate));
    } catch (e) {
      emit(ProfileError("Failed to schedule deletion: $e"));
    }
  }

  /// ✅ إلغاء الحذف قبل مرور 3 أيام
  Future<void> cancelAccountDeletion() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const ProfileError("User not logged in"));
      return;
    }

    emit(ProfileLoading());
    try {
      await _firestore.collection('users').doc(uid).update({
        'deletionScheduled': false,
        'deletionDate': null,
      });

      emit(DeletionCancelled());
    } catch (e) {
      emit(ProfileError("Failed to cancel deletion: $e"));
    }
  }

  /// ✅ حذف الحساب نهائيًا
  Future<void> deleteAccountNow() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const ProfileError("User not logged in"));
      return;
    }

    emit(ProfileLoading());
    try {
      await _firestore.collection('users').doc(uid).delete();
      await _auth.currentUser!.delete();
      await _secureStorage.deleteAll();

      emit(AccountDeleted());
    } catch (e) {
      emit(ProfileError("Failed to delete account: $e"));
    }
  }
}
