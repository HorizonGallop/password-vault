import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_cubit.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_state.dart';
import 'package:pswrd_vault/features/profile/widgets/delete_account_button.dart';
import 'package:pswrd_vault/features/profile/widgets/profile_header.dart';
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
            Navigator.pushReplacementNamed(context, '/google-auth');
          } else if (state is AccountDeleted) {
            Navigator.pushReplacementNamed(context, '/onboarding');
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(body: Center(child: LoadingOverlay()));
          }

          if (state is ProfileLoaded) {
            final user = state.user;

            return SafeArea(
              child: Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      ProfileHeader(
                        user: user,
                        onSignOut: () {
                          _confirmSignOut(context);
                        },
                      ),
                      SizedBox(height: 80),
                      SizedBox(height: 20),
                      DeleteAccountButton(
                        onDeleteAccount: () {
                          _confirmDeleteAccount(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: Center(child: Text('No profile data')),
          );
        },
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تأكيد تسجيل الخروج"),
        content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
        actions: [
          TextButton(
            child: const Text("إلغاء"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("تسجيل الخروج"),
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().signOut();
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("⚠️ حذف الحساب نهائيًا"),
        content: const Text(
          "هل أنت متأكد من حذف الحساب؟ سيتم حذف جميع البيانات من السحابة ومن جهازك بشكل نهائي ولا يمكن استعادتها.",
        ),
        actions: [
          TextButton(
            child: const Text("إلغاء"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("استمرار"),
            onPressed: () {
              Navigator.pop(context);
              _askForMasterPassword(context);
            },
          ),
        ],
      ),
    );
  }

  void _askForMasterPassword(BuildContext mainContext) {
    // (يمكنك هنا نقل هذه الدالة إلى ملف منفصل أو تبقى هنا حسب رغبتك)
  }
}
