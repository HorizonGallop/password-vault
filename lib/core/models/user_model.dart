import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? photoURL;
  final bool isAnonymous;
  final bool emailVerified;
  final String? tenantId;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;
  final List<Map<String, dynamic>> providerData;

  UserModel({
    required this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
    this.isAnonymous = false,
    this.emailVerified = false,
    this.tenantId,
    this.creationTime,
    this.lastSignInTime,
    this.providerData = const [],
  });

  /// ✅ تحويل لـ Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'isAnonymous': isAnonymous,
      'emailVerified': emailVerified,
      'tenantId': tenantId,
      'creationTime': creationTime?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
      'providerData': providerData,
    };
  }

  /// ✅ إنشاء من Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      displayName: map['name'], // تعديل هنا لاستخدام المفتاح الصحيح
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      isAnonymous: map['isAnonymous'] ?? false,
      emailVerified: map['emailVerified'] ?? false,
      tenantId: map['tenantId'],
      creationTime: _parseDate(map['creationTime']),
      lastSignInTime: _parseDate(map['lastSignInTime']),
      providerData: List<Map<String, dynamic>>.from(map['providerData'] ?? []),
    );
  }

  /// ✅ دعم Firestore Timestamp
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// ✅ إنشاء من JSON
  String toJson() => json.encode(toMap());

  /// ✅ إنشاء من JSON String
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  /// ✅ لإنشاء نسخة جديدة
  UserModel copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
  }) {
    return UserModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      isAnonymous: isAnonymous,
      emailVerified: emailVerified,
      tenantId: tenantId,
      creationTime: creationTime,
      lastSignInTime: lastSignInTime,
      providerData: providerData,
    );
  }
}
