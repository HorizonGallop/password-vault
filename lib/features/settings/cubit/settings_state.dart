part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final bool useBiometric;
  final String language;

  const SettingsState({
    required this.isLoading,
    required this.useBiometric,
    required this.language,
  });

  factory SettingsState.initial() =>
      const SettingsState(isLoading: true, useBiometric: false, language: 'en');

  SettingsState copyWith({
    bool? isLoading,
    bool? useBiometric,
    String? language,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      useBiometric: useBiometric ?? this.useBiometric,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [isLoading, useBiometric, language];
}
