import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/core/theme/cubit/theme_cubit.dart';
import 'package:pswrd_vault/features/settings/cubit/settings_cubit.dart';
import 'package:pswrd_vault/features/settings/widgets/3d_drop_down_menu.dart';
import 'package:pswrd_vault/features/widgets/app_info_card.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  return AppInfoCard(
                    title: 'Dark Mode',
                    subtitle: 'Switch between Light & Dark theme',
                    icon: Icons.brightness_6,
                    iconColor: Colors.amber,
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
                  return AppInfoCard(
                    title: 'Fingerprint Login',
                    subtitle: 'Enable or disable biometric login',
                    icon: Icons.fingerprint,
                    iconColor: Colors.green,
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
                  return AppInfoCard(
                    title: 'Language',
                    subtitle: 'Select your preferred language',
                    icon: Icons.language,
                    iconColor: Colors.blueAccent,
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
              AppInfoCard(
                title: 'About App',
                subtitle: 'Learn more about this application',
                icon: Icons.info_outline,
                iconColor: Colors.purple,
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
              AppInfoCard(
                title: 'Share App',
                subtitle: 'Invite friends to use this app',
                icon: Icons.share_rounded,
                iconColor: Colors.orangeAccent,
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
}
