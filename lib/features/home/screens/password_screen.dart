import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pswrd_vault/core/helper/encryption_helper.dart';
import 'package:pswrd_vault/core/models/password_model.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/home/cubit/home_cubit.dart';
import 'package:pswrd_vault/features/home/widgets/password_form_dialog.dart';
import 'package:pswrd_vault/features/widgets/app_info_card.dart';

class PasswordDetailsScreen extends StatelessWidget {
  static const routeName = '/password-details-screen';

  final PasswordModel passwordModel;
  final String masterPassword;

  const PasswordDetailsScreen({
    super.key,
    required this.passwordModel,
    required this.masterPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final decryptedEmail = _safeDecrypt(passwordModel.email);
    final decryptedPassword = _safeDecrypt(passwordModel.password);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: Image.asset(
            "assets/icons/arrow_back.png",
            height: 24,
            width: 24,
            color: colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(passwordModel.service, style: theme.textTheme.titleLarge),
        centerTitle: true,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.darkBackground, AppColors.darkCard]
                : [AppColors.lightBackground, AppColors.lightCard],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppInfoCard(
                  title: "الخدمة",
                  subtitle: passwordModel.service,
                  icon: Icons.apps,
                  iconColor: colorScheme.primary,
                ),
                AppInfoCard(
                  title: "اسم المستخدم",
                  subtitle: passwordModel.username,
                  icon: Icons.person,
                  iconColor: colorScheme.primary,
                  copyable: true,
                ),
                AppInfoCard(
                  title: "الإيميل",
                  subtitle: decryptedEmail,
                  icon: Icons.email,
                  iconColor: colorScheme.primary,
                  copyable: true,
                ),
                AppInfoCard(
                  title: "كلمة السر",
                  subtitle: decryptedPassword,
                  icon: Icons.lock,
                  iconColor: colorScheme.primary,
                  copyable: true,
                  isPassword: true,
                ),
                if (passwordModel.note != null &&
                    passwordModel.note!.isNotEmpty)
                  AppInfoCard(
                    title: "ملاحظات",
                    subtitle: passwordModel.note!,
                    icon: Icons.note_alt_outlined,
                    iconColor: colorScheme.primary,
                  ),
                AppInfoCard(
                  title: "تاريخ الإضافة",
                  subtitle: _formatDate(passwordModel.createdAt),
                  icon: Icons.calendar_today,
                  iconColor: colorScheme.primary,
                ),
                AppInfoCard(
                  title: "آخر تحديث",
                  subtitle: _formatDate(passwordModel.updatedAt),
                  icon: Icons.update,
                  iconColor: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),

      /// ✅ زر تعديل بسيط
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(bottom: 16.h),
          child: TextButton.icon(
            icon: Icon(Icons.edit, color: colorScheme.primary, size: 20.sp),
            label: Text(
              "تعديل",
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              final homeCubit = context.read<HomeCubit>();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  return BlocProvider.value(
                    value: homeCubit,
                    child: PasswordFormDialog(
                      existingPassword: passwordModel,
                      homeCubit: homeCubit,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _safeDecrypt(String value) {
    try {
      return EncryptionHelper.decryptText(value, masterPassword);
    } catch (_) {
      return value;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }
}
