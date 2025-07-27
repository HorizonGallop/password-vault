import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  Box? _settingsBox;

  SettingsCubit() : super(SettingsState.initial()) {
    _init();
  }

  Future<void> _init() async {
    _settingsBox = await Hive.openBox('settings');

    final useBiometric = _settingsBox!.get('useBiometric', defaultValue: false);
    final language = _settingsBox!.get('language', defaultValue: 'en');

    emit(
      state.copyWith(
        isLoading: false,
        useBiometric: useBiometric,
        language: language,
      ),
    );
  }

  Future<void> toggleBiometric(bool value) async {
    if (_settingsBox == null) return; // حماية إضافية
    await _settingsBox!.put('useBiometric', value);
    emit(state.copyWith(useBiometric: value));
  }

  Future<void> changeLanguage(String lang) async {
    if (_settingsBox == null) return;
    await _settingsBox!.put('language', lang);
    emit(state.copyWith(language: lang));
  }
}
