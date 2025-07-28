part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

/// ✅ حفظ كلمة السر
final class HomePasswordSaved extends HomeState {}

/// ✅ تعديل كلمة السر
final class HomePasswordUpdated extends HomeState {}

/// ✅ عرض/إخفاء كلمة السر
final class HomePasswordVisibilityChanged extends HomeState {
  final bool isVisible;
  HomePasswordVisibilityChanged(this.isVisible);
}

/// ✅ اختيار أيقونة لكلمة السر
final class HomePasswordIconChanged extends HomeState {
  final IconData selectedIcon;
  HomePasswordIconChanged(this.selectedIcon);
}

/// ✅ اختيار الفئة
final class HomeCategoryChanged extends HomeState {
  final String category;
  HomeCategoryChanged(this.category);
}

/// ✅ اختيار أيقونة للفئة
final class HomeCategoryIconChanged extends HomeState {
  final IconData selectedIcon;
  HomeCategoryIconChanged(this.selectedIcon);
}

/// ✅ تحديث كل القائمة بعد تعديل
final class HomeCategoriesUpdated extends HomeState {
  final Map<String, bool> expandedCategories;
  HomeCategoriesUpdated(this.expandedCategories);
}

/// ✅ حالة تحميل أثناء جلب أو حفظ كلمات السر
final class HomeLoading extends HomeState {}

/// ✅ حالة نجاح عند جلب البيانات
final class HomePasswordsLoaded extends HomeState {
  final List<PasswordModel> passwords;
  HomePasswordsLoaded(this.passwords);
}

/// ✅ حالة خطأ عند جلب أو حفظ البيانات
final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
