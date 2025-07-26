import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  bool _showSearch = false;
  bool _isPasswordVisible = false;

  IconData? _selectedPasswordIcon;
  String? _selectedCategory;
  IconData? _selectedCategoryIcon;

  /// ✅ أيقونات متاحة للاختيار
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

  /// ✅ الفئات المتاحة
  final List<String> categories = [
    "مواقع",
    "ألعاب",
    "خدمات",
    "عمل",
    "تسوق",
    "بنوك",
  ];

  HomeCubit() : super(HomeInitial());

  bool get isSearchVisible => _showSearch;
  bool get isPasswordVisible => _isPasswordVisible;
  IconData? get selectedPasswordIcon => _selectedPasswordIcon;
  String? get selectedCategory => _selectedCategory;
  IconData? get selectedCategoryIcon => _selectedCategoryIcon;

  /// ✅ إظهار أو إخفاء شريط البحث
  void toggleSearchBar() {
    _showSearch = !_showSearch;
    emit(HomeSearchVisibilityChanged(_showSearch));
  }

  /// ✅ إظهار أو إخفاء كلمة المرور
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(HomePasswordVisibilityChanged(_isPasswordVisible));
  }

  /// ✅ اختيار أيقونة لكلمة السر
  void selectPasswordIcon(IconData icon) {
    _selectedPasswordIcon = icon;
    emit(HomePasswordIconChanged(icon));
  }

  /// ✅ اختيار الفئة
  void selectCategory(String category) {
    _selectedCategory = category;
    emit(HomeCategoryChanged(category));
  }

  /// ✅ اختيار أيقونة للفئة
  void selectCategoryIcon(IconData icon) {
    _selectedCategoryIcon = icon;
    emit(HomeCategoryIconChanged(icon));
  }

  /// ✅ حفظ كلمة المرور
  void savePassword({
    required String service,
    required String email,
    required String username,
    required String password,
    IconData? passwordIcon,
    String? category,
    IconData? categoryIcon,
    String? note,
  }) {
    // هنا هتحفظ البيانات في Firebase أو Hive حسب مشروعك
    emit(HomePasswordSaved());
  }

  /// ✅ توليد كلمة مرور عشوائية
  String generateRandomPassword({int length = 12}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$%&*';
    final rand = Random();
    return List.generate(
      length,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }
}
