import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pswrd_vault/core/theme/app_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.darkTheme);

  Future<void> loadTheme() async {
    final box = await Hive.openBox('settings');
    final isDark = box.get('isDark', defaultValue: true);
    emit(isDark ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  Future<void> toggleTheme() async {
    final box = await Hive.openBox('settings');
    final isDark = state.brightness == Brightness.dark;
    await box.put('isDark', !isDark);
    emit(!isDark ? AppTheme.darkTheme : AppTheme.lightTheme);
  }
}
