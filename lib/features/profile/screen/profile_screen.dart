import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/features/onboarding/screens/onboarding_screen.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_cubit.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_state.dart';
import 'package:pswrd_vault/features/profile/widgets/delete_account_button.dart';
import 'package:pswrd_vault/features/profile/widgets/dialogs.dart';
import 'package:pswrd_vault/features/profile/widgets/no_internet_widget.dart';
import 'package:pswrd_vault/features/profile/widgets/profile_header.dart';
import 'package:pswrd_vault/features/splash/screen/splash_screen.dart';
import 'package:pswrd_vault/features/widgets/loading_widget.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadUserProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is SignedOut) {
            Navigator.pushReplacementNamed(context, SplashScreen.routeName);
          } else if (state is AccountDeleted) {
            Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(body: Center(child: LoadingOverlay()));
          }

          return Scaffold(
            resizeToAvoidBottomInset: true, // ✅ التعامل مع الكيبورد
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                child: _buildContent(context, state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfileState state) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state is ProfileLoaded) {
      final user = state.user;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(
            user: user,
            onSignOut: () => showSignOutDialog(context),
          ),
          SizedBox(height: 80.h),
          Center(
            child: DeleteAccountButton(
              onDeleteAccount: () => showDeleteAccountDialog(context),
            ),
          ),
        ],
      );
    }

    if (state is NoInternetConnection) {
      return NoInternetWidget(
        onRetry: () => context.read<ProfileCubit>().loadUserProfile(),
      );
    }

    return Center(
      child: Text(
        'لا توجد بيانات لعرضها',
        style: TextStyle(color: colorScheme.onBackground),
      ),
    );
  }
}
