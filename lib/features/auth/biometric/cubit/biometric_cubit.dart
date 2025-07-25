import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

part 'biometric_state.dart';

class BiometricCubit extends Cubit<BiometricState> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  BiometricCubit() : super(BiometricInitial());

  Future<void> authenticate() async {
    emit(BiometricChecking());
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;

      if (!isSupported || !canCheckBiometrics) {
        emit(const BiometricFailure('Biometric authentication not available'));
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock vault',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (didAuthenticate) {
        emit(BiometricSuccess());
      } else {
        emit(const BiometricFailure('Authentication failed'));
      }
    } catch (e) {
      emit(BiometricFailure('Error: $e'));
    }
  }
}
