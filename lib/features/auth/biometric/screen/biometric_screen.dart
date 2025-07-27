import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/auth/biometric/cubit/biometric_cubit.dart';
import 'package:pswrd_vault/features/auth/verify-password/screen/verify_master_password_screen.dart';
import 'package:pswrd_vault/features/navigation/screen/bottom_nav_screen.dart';

class BiometricAuthScreen extends StatelessWidget {
  static const routeName = '/biometric-screen';
  const BiometricAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BiometricCubit()..authenticate(), // يبدأ التحقق تلقائي
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<BiometricCubit, BiometricState>(
            listener: (context, state) {
              if (state is BiometricSuccess) {
                Navigator.pushReplacementNamed(
                  context,
                  BottomNavScreen.routeName,
                );
              } else if (state is BiometricFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/finger_print.json',
                        width: 180,
                        height: 180,
                        repeat: true,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'ضع إصبعك للتأكيد',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      if (state is BiometricChecking)
                        const CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      const SizedBox(height: 32),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            VerifyMasterPasswordScreen.routeName,
                          );
                        },
                        child:  Text(
                          'استخدام الماستر باسوورد',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
