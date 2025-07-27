import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pswrd_vault/core/theme/cubit/theme_cubit.dart';
import 'package:pswrd_vault/features/settings/cubit/settings_cubit.dart';
import 'core/routing/app_router.dart';
import 'features/auth/google-signin/cubit/google_auth_cubit.dart';
import 'features/navigation/cubit/navigation_cubit.dart';
import 'features/onboarding/cubit/onboarding_cubit.dart';
import 'features/splash/cubit/splash_cubit.dart';
import 'features/splash/screen/splash_screen.dart';
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
  const secureStorage = FlutterSecureStorage();
  var encryptionKey = await secureStorage.read(key: 'hive_encryption_key');
  if (encryptionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(key: 'hive_encryption_key', value: key.join(','));
    encryptionKey = key.join(',');
  }
  final keyList = encryptionKey.split(',').map(int.parse).toList();
  await Hive.openBox('userBox', encryptionCipher: HiveAesCipher(keyList));
  await Hive.openBox('settings'); // لتخزين الثيم
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
            BlocProvider(create: (_) => GoogleAuthCubit()),
            BlocProvider(create: (_) => SplashCubit()),
            BlocProvider(create: (_) => OnboardingCubit()),
            BlocProvider(create: (_) => NavigationCubit()),
            BlocProvider(create: (_) => SettingsCubit()),
            BlocProvider(create: (_) => ThemeCubit()..loadTheme()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Pswrd Vault',
                theme: theme,
                initialRoute: SplashScreen.routeName,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          ),
        );
      },
    );
  }
}
