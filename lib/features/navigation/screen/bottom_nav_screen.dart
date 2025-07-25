import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/navigation/cubit/navigation_cubit.dart';
import 'package:pswrd_vault/features/navigation/cubit/navigation_state.dart';
import 'package:pswrd_vault/features/home/screens/home_screen.dart';
import 'package:pswrd_vault/features/profile/screen/profile_screen.dart';
import 'package:pswrd_vault/features/settings/screen/settings_screen.dart';

class BottomNavScreen extends StatelessWidget {
  static const routeName = '/bottom-nav-screen';

  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [ProfileScreen(), HomeScreen(), SettingsScreen()];

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
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  final currentIndex = (state is NavigationChanged)
                      ? state.currentIndex
                      : 1;
                  return GNav(
                    rippleColor: AppColors.secondary,
                    hoverColor: AppColors.secondary,
                    gap: 8,
                    activeColor: AppColors.white,
                    color: AppColors.secondary,
                    iconSize: 24.sp,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    duration: const Duration(milliseconds: 300),
                    tabBackgroundColor: AppColors.primary,
                    selectedIndex: currentIndex,
                    onTabChange: (index) =>
                        context.read<NavigationCubit>().changeTab(index),
                    tabs: const [
                      GButton(icon: Icons.person, text: "Profile"),
                      GButton(icon: Icons.home, text: "Home"),
                      GButton(icon: Icons.settings, text: "Settings"),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
