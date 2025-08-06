import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pswrd_vault/core/helper/encryption_helper.dart';
import 'package:pswrd_vault/core/models/password_model.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/home/cubit/home_cubit.dart';
import 'package:pswrd_vault/features/home/widgets/password_form_dialog.dart';
import 'package:pswrd_vault/features/widgets/app_info_card.dart';

class PasswordDetailsScreen extends StatefulWidget {
  static const routeName = '/password-details-screen';

  final PasswordModel passwordModel;

  const PasswordDetailsScreen({super.key, required this.passwordModel});

  @override
  State<PasswordDetailsScreen> createState() => _PasswordDetailsScreenState();
}

class _PasswordDetailsScreenState extends State<PasswordDetailsScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();

  bool isLoading = true;
  String? decryptedEmail;
  String? decryptedPassword;
  String? masterPassword;

  @override
  void initState() {
    super.initState();
    _authenticateAndLoad();
  }

  Future<void> _authenticateAndLoad() async {
    try {
      /// ✅ التحقق بالبصمة أولاً
      bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'يرجى التحقق بالبصمة للوصول إلى كلمات المرور',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (!didAuthenticate) {
        if (mounted) Navigator.pop(context);
        return;
      }

      /// ✅ جلب الماستر باسوورد من Secure Storage
      masterPassword = await _secureStorage.read(key: 'master_password');

      if (masterPassword != null) {
        decryptedEmail = EncryptionHelper.decryptText(
          widget.passwordModel.email,
          masterPassword!,
        );
        decryptedPassword = EncryptionHelper.decryptText(
          widget.passwordModel.password,
          masterPassword!,
        );
      } else {
        decryptedEmail = widget.passwordModel.email; // في حالة الفشل
        decryptedPassword = widget.passwordModel.password;
      }
    } catch (e) {
      decryptedEmail = widget.passwordModel.email;
      decryptedPassword = widget.passwordModel.password;
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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
        title: Text(
          widget.passwordModel.service,
          style: theme.textTheme.titleLarge,
        ),
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
                  subtitle: widget.passwordModel.service,
                  icon: Icons.apps,
                  iconColor: colorScheme.primary,
                ),
                AppInfoCard(
                  title: "اسم المستخدم",
                  subtitle: widget.passwordModel.username,
                  icon: Icons.person,
                  iconColor: colorScheme.primary,
                  copyable: true,
                ),
                AppInfoCard(
                  title: "الإيميل",
                  subtitle: decryptedEmail ?? '',
                  icon: Icons.email,
                  iconColor: colorScheme.primary,
                  copyable: true,
                  isSensitive: true,
                ),
                AppInfoCard(
                  title: "كلمة السر",
                  subtitle: decryptedPassword ?? '',
                  icon: Icons.lock,
                  iconColor: colorScheme.primary,
                  copyable: true,
                  isPassword: true,
                ),
                if (widget.passwordModel.note != null &&
                    widget.passwordModel.note!.isNotEmpty)
                  AppInfoCard(
                    title: "ملاحظات",
                    subtitle: widget.passwordModel.note!,
                    icon: Icons.note_alt_outlined,
                    iconColor: colorScheme.primary,
                  ),
                AppInfoCard(
                  title: "تاريخ الإضافة",
                  subtitle: _formatDate(widget.passwordModel.createdAt),
                  icon: Icons.calendar_today,
                  iconColor: colorScheme.primary,
                ),
                AppInfoCard(
                  title: "آخر تحديث",
                  subtitle: _formatDate(widget.passwordModel.updatedAt),
                  icon: Icons.update,
                  iconColor: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
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
                      existingPassword: widget.passwordModel,
                      homeCubit: homeCubit,
                      masterPassword: masterPassword!,
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

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }
}
