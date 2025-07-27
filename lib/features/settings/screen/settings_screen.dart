import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/core/theme/cubit/theme_cubit.dart';
import 'package:pswrd_vault/features/settings/cubit/settings_cubit.dart';
import 'package:pswrd_vault/features/settings/widgets/3d_drop_down_menu.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              Center(
                child: Image.asset("assets/icons/app_icon.png", height: 100),
              ),
              SizedBox(height: 32.h),

              // ✅ Dark Mode
              BlocBuilder<ThemeCubit, ThemeData>(
                builder: (context, themeState) {
                  return _buildSettingCard(
                    context: context,
                    icon: Icons.brightness_6,
                    iconColor: Colors.amber,
                    title: 'Dark Mode',
                    subtitle: 'Switch between Light & Dark theme',
                    trailing: Switch(
                      value: themeState.brightness == Brightness.dark,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().toggleTheme(),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // ✅ Fingerprint
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.useBiometric != current.useBiometric,
                builder: (context, state) {
                  return _buildSettingCard(
                    context: context,
                    icon: Icons.fingerprint,
                    iconColor: Colors.green,
                    title: 'Fingerprint Login',
                    subtitle: 'Enable or disable biometric login',
                    trailing: Switch(
                      value: state.useBiometric,
                      onChanged: (value) {
                        context.read<SettingsCubit>().toggleBiometric(value);
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // ✅ Language
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.language != current.language,
                builder: (context, state) {
                  return _buildSettingCard(
                    context: context,
                    icon: Icons.language,
                    iconColor: Colors.blueAccent,
                    title: 'Language',
                    subtitle: 'Select your preferred language',
                    trailing: SizedBox(
                      width: 100.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Custom3DDropdown<String>(
                          width: 100.w,
                          value: state.language,
                          hintText: "Select",
                          items: const [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: 'ar',
                              child: Text('العربية'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null)
                              context.read<SettingsCubit>().changeLanguage(val);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // ✅ About App
              _buildSettingCard(
                context: context,
                icon: Icons.info_outline,
                iconColor: Colors.purple,
                title: 'About App',
                subtitle: 'Learn more about this application',
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: theme.iconTheme.color,
                ),
                onTap: () {
                  // TODO: Navigate to About App screen
                },
              ),
              SizedBox(height: 16.h),

              // ✅ Share App
              _buildSettingCard(
                context: context,
                icon: Icons.share_rounded,
                iconColor: Colors.orangeAccent,
                title: 'Share App',
                subtitle: 'Invite friends to use this app',
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: theme.iconTheme.color,
                ),
                onTap: () async {
                  await Share.share(
                    'Check out this amazing app! Download it now: https://play.google.com/store/apps/details?id=com.example.pswrd_vault',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 28.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: theme.hintColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
