import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/models/user_model.dart';
import 'package:pswrd_vault/features/profile/widgets/sign_out_button.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final dynamic onSignOut;

  const ProfileHeader({required this.user, super.key, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: colorScheme.surface.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 8,
        shadowColor: colorScheme.shadow,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 45.r,
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: user.photoURL == null
                    ? Icon(
                        Icons.person,
                        size: 56,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      )
                    : null,
              ),
              SizedBox(height: 12.h),
              Text(
                user.displayName ?? 'No Name',
                style: textTheme.titleLarge!.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                user.email ?? '',
                style: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 16.h),
              SignOutButton(onSignOut: onSignOut),
            ],
          ),
        ),
      ),
    );
  }
}
