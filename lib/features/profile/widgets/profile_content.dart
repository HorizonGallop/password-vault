import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_cubit.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_state.dart';
import 'package:pswrd_vault/features/profile/widgets/delete_account_button.dart';
import 'package:pswrd_vault/features/profile/widgets/dialogs.dart';
import 'package:pswrd_vault/features/profile/widgets/no_internet_widget.dart';
import 'package:pswrd_vault/features/profile/widgets/profile_header.dart';

class ProfileContent extends StatelessWidget {
  final ProfileState state;

  const ProfileContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state is ProfileLoaded) {
      final user = (state as ProfileLoaded).user;

      return Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            ProfileHeader(
              user: user,
              onSignOut: () => showSignOutDialog(context),
            ),
            SizedBox(height: 80.h),
            DeleteAccountButton(
              onDeleteAccount: () => showDeleteAccountDialog(context),
            ),
          ],
        ),
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
