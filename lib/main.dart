import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:pswrd_vault/core/routing/app_router.dart';
import 'package:pswrd_vault/core/utils/app_theme.dart';
import 'package:pswrd_vault/features/auth/google-signin/cubit/google_auth_cubit.dart';
import 'package:pswrd_vault/features/navigation/cubit/navigation_cubit.dart';
import 'package:pswrd_vault/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:pswrd_vault/features/splash/cubit/splash_cubit.dart';
import 'package:pswrd_vault/features/splash/screen/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();
  await _initializeHive();

  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
}

Future<void> _initializeHive() async {
  await Hive.initFlutter();

  // ✅ Generate or get encryption key for Hive
  const secureStorage = FlutterSecureStorage();
  var encryptionKey = await secureStorage.read(key: 'hive_encryption_key');

  if (encryptionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(key: 'hive_encryption_key', value: key.join(','));
    encryptionKey = key.join(',');
  }

  // ✅ Convert stored key back to List<int>
  final keyList = encryptionKey.split(',').map(int.parse).toList();

  // ✅ Open userBox with encryption
  await Hive.openBox('userBox', encryptionCipher: HiveAesCipher(keyList));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<GoogleAuthCubit>(
              create: (_) => GoogleAuthCubit(),
            ), // ✅ أضفنا GoogleAuthCubit
            BlocProvider<SplashCubit>(create: (_) => SplashCubit()),
            BlocProvider<OnboardingCubit>(create: (_) => OnboardingCubit()),
            BlocProvider<NavigationCubit>(
              create: (_) => NavigationCubit(),
            ), // ✅ للـ BottomNav
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pswrd Vault',
            theme: AppTheme.darkTheme,
            initialRoute: SplashScreen.routeName,
            onGenerateRoute: AppRouter.onGenerateRoute,
          ),
        );
      },
    );
  }
}
