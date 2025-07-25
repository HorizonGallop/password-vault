import 'dart:convert';

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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      displayName: map['displayName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      isAnonymous: map['isAnonymous'] ?? false,
      emailVerified: map['emailVerified'] ?? false,
      tenantId: map['tenantId'],
      creationTime: map['creationTime'] != null
          ? DateTime.parse(map['creationTime'])
          : null,
      lastSignInTime: map['lastSignInTime'] != null
          ? DateTime.parse(map['lastSignInTime'])
          : null,
      providerData: List<Map<String, dynamic>>.from(map['providerData'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
