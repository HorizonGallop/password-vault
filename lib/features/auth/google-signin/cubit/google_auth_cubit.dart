import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pswrd_vault/core/models/user_model.dart';
import 'google_auth_state.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  GoogleAuthCubit() : super(GoogleAuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _userKey = 'logged_in_user';

  /// ✅ تسجيل الدخول بجوجل + حفظ المستخدم في Firestore + تخزينه محليًا
  Future<void> signInWithGoogle() async {
    emit(GoogleAuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(const GoogleAuthFailure("Sign-in cancelled by user"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        emit(const GoogleAuthFailure("User data not found"));
        return;
      }

      final docRef = _firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();

      bool needsMasterPassword = false;

      if (!doc.exists) {
        await docRef.set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'photoURL': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'hasMasterPassword': false,
        });
        needsMasterPassword = true;
      } else {
        needsMasterPassword = !(doc.data()?['hasMasterPassword'] == true);
      }

      // ✅ بناء UserModel
      final userModel = UserModel(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL,
        isAnonymous: user.isAnonymous,
        emailVerified: user.emailVerified,
        tenantId: user.tenantId,
        creationTime: user.metadata.creationTime,
        lastSignInTime: user.metadata.lastSignInTime,
        providerData: user.providerData.map((info) {
          return {
            'providerId': info.providerId,
            'uid': info.uid,
            'displayName': info.displayName,
            'email': info.email,
            'photoURL': info.photoURL,
            'phoneNumber': info.phoneNumber,
          };
        }).toList(),
      );

      // ✅ حفظ محلي
      await _saveUserLocally(userModel);

      emit(GoogleAuthSuccess(needsMasterPassword: needsMasterPassword));
    } catch (e) {
      emit(GoogleAuthFailure("Sign-in failed: ${e.toString()}"));
    }
  }

  /// ✅ حفظ المستخدم محليًا
  Future<void> _saveUserLocally(UserModel user) async {
    await _secureStorage.write(key: _userKey, value: user.toJson());
  }

  /// ✅ جلب المستخدم المخزن محليًا
  Future<UserModel?> getLocalUser() async {
    final jsonString = await _secureStorage.read(key: _userKey);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonString);
  }

  /// ✅ حذف بيانات المستخدم المحلية
  Future<void> clearLocalUser() async {
    await _secureStorage.delete(key: _userKey);
  }

  /// ✅ جلب الـ UID الحالي
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}
