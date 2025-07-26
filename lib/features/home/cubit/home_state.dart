part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeSearchVisibilityChanged extends HomeState {
  final bool showSearch;
  HomeSearchVisibilityChanged(this.showSearch);
}

final class HomePasswordSaved extends HomeState {}

final class HomePasswordVisibilityChanged extends HomeState {
  final bool isVisible;
  HomePasswordVisibilityChanged(this.isVisible);
}

/// ✅ حالة عند اختيار أيقونة لكلمة السر
final class HomePasswordIconChanged extends HomeState {
  final IconData selectedIcon;
  HomePasswordIconChanged(this.selectedIcon);
}

/// ✅ حالة عند اختيار الفئة
final class HomeCategoryChanged extends HomeState {
  final String category;
  HomeCategoryChanged(this.category);
}

/// ✅ حالة عند اختيار أيقونة للفئة
final class HomeCategoryIconChanged extends HomeState {
  final IconData selectedIcon;
  HomeCategoryIconChanged(this.selectedIcon);
}
