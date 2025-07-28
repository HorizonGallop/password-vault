import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordModel {
  final String id;
  final String service;
  final String email;
  final String username;
  final String password;
  final String category;
  final String? passwordIcon; // اسم الأيقونة المختارة
  final String? categoryIcon; // اسم أيقونة الفئة
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  PasswordModel({
    required this.id,
    required this.service,
    required this.email,
    required this.username,
    required this.password,
    required this.category,
    this.passwordIcon,
    this.categoryIcon,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  /// ✅ إنشاء نسخة جديدة مع التعديلات
  PasswordModel copyWith({
    String? id,
    String? service,
    String? email,
    String? username,
    String? password,
    String? category,
    String? passwordIcon,
    String? categoryIcon,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PasswordModel(
      id: id ?? this.id,
      service: service ?? this.service,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      category: category ?? this.category,
      passwordIcon: passwordIcon ?? this.passwordIcon,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// ✅ لتحويل إلى Map (لتخزين في Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service': service,
      'email': email,
      'username': username,
      'password': password,
      'category': category,
      'passwordIcon': passwordIcon,
      'categoryIcon': categoryIcon,
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// ✅ تحويل من Map (للقراءة من Firestore)
  factory PasswordModel.fromMap(Map<String, dynamic> map) {
    return PasswordModel(
      id: map['id'] ?? '',
      service: map['service'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      category: map['category'] ?? '',
      passwordIcon: map['passwordIcon'],
      categoryIcon: map['categoryIcon'],
      note: map['note'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
