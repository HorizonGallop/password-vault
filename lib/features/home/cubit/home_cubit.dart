import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/helper/encryption_helper.dart';
import 'package:pswrd_vault/core/models/password_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String masterPassword;

  bool _isPasswordVisible = false;

  IconData? _selectedPasswordIcon;
  String? _selectedCategory;
  IconData? _selectedCategoryIcon;

  List<PasswordModel> _passwords = [];
  List<PasswordModel> get passwords => _passwords;

  StreamSubscription? _passwordsSubscription;

  /// قائمة أيقونات متاحة لكلمات السر
  final List<IconData> availableIcons = [
    Icons.lock,
    Icons.vpn_key,
    Icons.security,
    Icons.gamepad,
    Icons.shopping_cart,
    Icons.work,
    Icons.web,
    Icons.credit_card,
    Icons.email,
    Icons.folder,
  ];

  /// قائمة الفئات المتاحة
  final List<String> categories = [
    "Social Media",
    "Messaging",
    "Work",
    "Productivity",
    "Collaboration",
    "Shopping",
    "Banks",
    "Payments",
    "Websites",
    "Apps",
    "Forums",
    "Games",
    "Streaming",
    "Music",
    "Video",
    "Education",
    "Courses",
    "E-learning",
    "Health",
    "Fitness",
    "Travel",
    "Cloud Storage",
    "Email",
    "Crypto & Wallets",
    "Government & Services",
    "Devices & Routers",
    "Hosting & Domains",
    "Other",
  ];

  /// أيقونات الفئات
  final Map<String, IconData> categoryIcons = {
    "Social Media": Icons.people,
    "Messaging": Icons.message,
    "Work": Icons.work,
    "Productivity": Icons.task,
    "Collaboration": Icons.group_work,
    "Shopping": Icons.shopping_cart,
    "Banks": Icons.account_balance,
    "Payments": Icons.payment,
    "Websites": Icons.web,
    "Apps": Icons.apps,
    "Forums": Icons.forum,
    "Games": Icons.sports_esports,
    "Streaming": Icons.live_tv,
    "Music": Icons.music_note,
    "Video": Icons.videocam,
    "Education": Icons.school,
    "Courses": Icons.menu_book,
    "E-learning": Icons.computer,
    "Health": Icons.health_and_safety,
    "Fitness": Icons.fitness_center,
    "Travel": Icons.flight_takeoff,
    "Cloud Storage": Icons.cloud,
    "Email": Icons.email,
    "Crypto & Wallets": Icons.currency_bitcoin,
    "Government & Services": Icons.account_balance_wallet,
    "Devices & Routers": Icons.router,
    "Hosting & Domains": Icons.domain,
    "Other": Icons.more_horiz,
  };

  /// حالة التوسيع لكل فئة (مفتوح أو مغلق)
  final Map<String, bool> _expandedCategories = {};

  HomeCubit({required this.masterPassword}) : super(HomeInitial()) {
    // تهيئة حالة التوسيع لكل فئة
    for (var category in categories) {
      _expandedCategories[category] = false;
    }
  }

  // getters للوصول إلى الحالات الخاصة
  bool get isPasswordVisible => _isPasswordVisible;

  IconData? get selectedPasswordIcon => _selectedPasswordIcon;
  String? get selectedCategory => _selectedCategory;
  IconData? get selectedCategoryIcon => _selectedCategoryIcon;
  Map<String, bool> get expandedCategories => _expandedCategories;

  /// إعادة ترتيب كلمات السر حسب الفئات
  Map<String, List<PasswordModel>> get passwordsGroupedByCategory {
    final Map<String, List<PasswordModel>> map = {};
    for (var pwd in _passwords) {
      final category = pwd.category;
      map.putIfAbsent(category, () => []);
      map[category]!.add(pwd);
    }
    return map;
  }

  /// تبديل رؤية كلمة السر
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(HomePasswordVisibilityChanged(_isPasswordVisible));
  }

  /// تحديد أيقونة كلمة السر المختارة
  void selectPasswordIcon(IconData icon) {
    _selectedPasswordIcon = icon;
    emit(HomePasswordIconChanged(icon));
  }

  /// تحديد الفئة المختارة وتحديث الأيقونة الخاصة بها
  void selectCategory(String category) {
    _selectedCategory = category;
    _selectedCategoryIcon = categoryIcons[category];
    emit(HomeCategoryChanged(category));
  }

  /// تبديل حالة التوسيع لفئة معينة
  void toggleCategoryExpanded(String category) {
    if (_expandedCategories.containsKey(category)) {
      _expandedCategories[category] = !_expandedCategories[category]!;
      emit(HomeCategoriesUpdated(Map.from(_expandedCategories)));
    }
  }

  /// حفظ كلمة سر جديدة مع تشفير الحقول الحساسة
  Future<void> savePassword({
    required String service,
    required String email,
    required String username,
    required String password,
    IconData? passwordIcon,
    String? category,
    IconData? categoryIcon,
    String? note,
  }) async {
    try {
      emit(HomeLoading());

      final id = _firestore.collection('passwords').doc().id;

      final encryptedEmail = EncryptionHelper.encryptText(
        email,
        masterPassword,
      );
      final encryptedPassword = EncryptionHelper.encryptText(
        password,
        masterPassword,
      );

      final model = PasswordModel(
        id: id,
        service: service,
        email: encryptedEmail,
        username: username,
        password: encryptedPassword,
        category: category ?? 'Other',
        passwordIcon: passwordIcon?.codePoint.toString(),
        categoryIcon: categoryIcon?.codePoint.toString(),
        note: note,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('passwords').doc(id).set(model.toMap());
      emit(HomePasswordSaved());
    } catch (e) {
      emit(HomeError("فشل في حفظ كلمة السر: $e"));
    }
  }

  /// تعديل كلمة سر موجودة
  Future<void> updatePassword({
    required String id,
    required String service,
    required String email,
    required String username,
    required String password,
    IconData? passwordIcon,
    String? category,
    IconData? categoryIcon,
    String? note,
  }) async {
    try {
      emit(HomeLoading());

      final encryptedEmail = EncryptionHelper.encryptText(
        email,
        masterPassword,
      );
      final encryptedPassword = EncryptionHelper.encryptText(
        password,
        masterPassword,
      );

      final updatedData = {
        'service': service,
        'email': encryptedEmail,
        'username': username,
        'password': encryptedPassword,
        'category': category ?? 'Other',
        'passwordIcon': passwordIcon?.codePoint.toString(),
        'categoryIcon': categoryIcon?.codePoint.toString(),
        'note': note,
        'updatedAt': DateTime.now(),
      };

      await _firestore.collection('passwords').doc(id).update(updatedData);

      emit(HomePasswordSaved());
    } catch (e) {
      emit(HomeError("فشل في تحديث كلمة السر: $e"));
    }
  }

  /// الاستماع المباشر لتحديثات كلمات السر من Firestore
  void listenPasswords() {
    emit(HomeLoading());

    _passwordsSubscription?.cancel();

    _passwordsSubscription = _firestore
        .collection('passwords')
        .snapshots()
        .listen(
          (snapshot) {
            _passwords = snapshot.docs.map((doc) {
              final data = doc.data();

              String decryptedEmail = "";
              String decryptedPassword = "";

              try {
                decryptedEmail = EncryptionHelper.decryptText(
                  data['email'],
                  masterPassword,
                );
                decryptedPassword = EncryptionHelper.decryptText(
                  data['password'],
                  masterPassword,
                );
              } catch (_) {
                decryptedEmail = "****";
                decryptedPassword = "****";
              }

              return PasswordModel.fromMap({
                ...data,
                'id': doc.id,
                'email': decryptedEmail,
                'password': decryptedPassword,
              });
            }).toList();

            emit(HomePasswordsLoaded(List.from(_passwords)));
          },
          onError: (error) {
            emit(HomeError("فشل في تحميل البيانات: $error"));
          },
        );
  }

  @override
  Future<void> close() {
    _passwordsSubscription?.cancel();
    return super.close();
  }
}
