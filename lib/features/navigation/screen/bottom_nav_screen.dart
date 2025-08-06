import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pswrd_vault/features/navigation/cubit/navigation_cubit.dart';
import 'package:pswrd_vault/features/navigation/cubit/navigation_state.dart';
import 'package:pswrd_vault/features/home/cubit/home_cubit.dart';
import 'package:pswrd_vault/features/home/screens/home_screen.dart';
import 'package:pswrd_vault/features/profile/screen/profile_screen.dart';
import 'package:pswrd_vault/features/settings/screen/settings_screen.dart';

class BottomNavScreen extends StatelessWidget {
  static const routeName = '/bottom-nav-screen';

  final String masterPassword;

  const BottomNavScreen({super.key, required this.masterPassword});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(
          create: (_) =>
              HomeCubit(masterPassword: masterPassword)..listenPasswords(),
        ),
      ],
      child: Builder(
        builder: (context) {
          /// ✅ الصفحات (ما تعملش Cubit هنا)
          final pages = [
            const ProfileScreen(),
            const HomeScreen(), // ✅ بدون تمرير Cubit أو MasterPassword
            const SettingsScreen(),
          ];

          return Scaffold(
            body: BlocBuilder<NavigationCubit, NavigationState>(
              builder: (context, state) {
                final currentIndex = (state is NavigationChanged)
                    ? state.currentIndex
                    : 1;
                return IndexedStack(index: currentIndex, children: pages);
              },
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 32.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    child: BlocBuilder<NavigationCubit, NavigationState>(
                      builder: (context, state) {
                        final currentIndex = (state is NavigationChanged)
                            ? state.currentIndex
                            : 1;
                        return GNav(
                          rippleColor: colorScheme.primary.withOpacity(0.1),
                          hoverColor: colorScheme.primary.withOpacity(0.1),
                          gap: 8,
                          activeColor: colorScheme.onPrimary,
                          color: colorScheme.onSurface,
                          iconSize: 24.sp,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          duration: const Duration(milliseconds: 300),
                          tabBackgroundColor: colorScheme.primary,
                          selectedIndex: currentIndex,
                          onTabChange: (index) =>
                              context.read<NavigationCubit>().changeTab(index),
                          tabs: const [
                            GButton(icon: Icons.person),
                            GButton(icon: Icons.home),
                            GButton(icon: Icons.settings),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
