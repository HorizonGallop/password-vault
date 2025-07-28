import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/core/models/password_model.dart';
import '../cubit/home_cubit.dart';

class PasswordFormDialog extends StatefulWidget {
  final PasswordModel? existingPassword;
  final HomeCubit homeCubit;

  const PasswordFormDialog({
    super.key,
    this.existingPassword,
    required this.homeCubit,
  });

  @override
  State<PasswordFormDialog> createState() => _PasswordFormDialogState();
}

class _PasswordFormDialogState extends State<PasswordFormDialog> {
  final serviceController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final noteController = TextEditingController();

  final Map<String, String?> errors = {
    'service': null,
    'email': null,
    'username': null,
    'password': null,
    'icon': null,
    'category': null,
  };

  @override
  void initState() {
    super.initState();
    if (widget.existingPassword != null) {
      final pwd = widget.existingPassword!;
      serviceController.text = pwd.service;
      emailController.text = pwd.email;
      usernameController.text = pwd.username;
      passwordController.text = pwd.password;
      noteController.text = pwd.note ?? '';
      widget.homeCubit.selectPasswordIcon(
        IconData(
          int.parse(pwd.passwordIcon ?? '0'),
          fontFamily: 'MaterialIcons',
        ),
      );
      widget.homeCubit.selectCategory(pwd.category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final cubit = widget.homeCubit;

    final isEditMode = widget.existingPassword != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 80.h),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? "تعديل كلمة المرور" : "إضافة كلمة مرور جديدة",
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            _buildTextField("اسم الخدمة", serviceController, 'service'),
            const SizedBox(height: 12),

            _buildTextField("البريد الإلكتروني", emailController, 'email'),
            const SizedBox(height: 12),

            _buildTextField("اسم المستخدم", usernameController, 'username'),
            const SizedBox(height: 12),

            _buildPasswordField(
              passwordController,
              cubit.isPasswordVisible,
              cubit.togglePasswordVisibility,
              'password',
            ),
            const SizedBox(height: 16),

            Text(
              "اختر أيقونة لكلمة السر",
              style: textTheme.bodyMedium!.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                IconData? icon = await showIconPicker(
                  context,
                  iconPackModes: [IconPack.material, IconPack.fontAwesomeIcons],
                  title: const Text('اختر أيقونة'),
                  searchHintText: 'ابحث عن أيقونة...',
                  closeChild: const Text('إغلاق'),
                  backgroundColor: colorScheme.surface,
                  iconColor: colorScheme.primary,
                  adaptiveDialog: false,
                  constraints: const BoxConstraints(maxWidth: 400),
                  iconPickerShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
                if (icon != null) {
                  setState(() {
                    cubit.selectPasswordIcon(icon);
                    errors['icon'] = null;
                  });
                }
              },
              icon: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  cubit.selectedPasswordIcon ?? Icons.add_circle_outline,
                  size: 32,
                  color: colorScheme.primary,
                ),
              ),
              label: Text(
                cubit.selectedPasswordIcon == null
                    ? 'اختيار أيقونة'
                    : 'تغيير الأيقونة',
                style: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
            if (errors['icon'] != null)
              Text(errors['icon']!, style: _errorStyle()),
            const SizedBox(height: 16),

            _buildTextField(
              "الوصف (اختياري)",
              noteController,
              null,
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            Text(
              "اختر الفئة",
              style: textTheme.bodyMedium!.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              dropdownColor: colorScheme.surface,
              value:
                  (cubit.selectedCategory == null ||
                      cubit.selectedCategory!.isEmpty)
                  ? null
                  : cubit.selectedCategory,
              hint: const Text('اختر الفئة'),
              items: cubit.categories.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      Icon(cubit.categoryIcons[e], size: 20),
                      const SizedBox(width: 8),
                      Text(e, style: textTheme.bodyMedium),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  cubit.selectCategory(value ?? '');
                  errors['category'] = null;
                });
              },
              decoration: _dropdownDecoration(context),
            ),
            if (errors['category'] != null)
              Text(errors['category']!, style: _errorStyle()),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    errors['service'] = serviceController.text.isEmpty
                        ? 'اسم الخدمة مطلوب'
                        : null;
                    errors['email'] = emailController.text.isEmpty
                        ? 'البريد الإلكتروني مطلوب'
                        : null;
                    errors['username'] = usernameController.text.isEmpty
                        ? 'اسم المستخدم مطلوب'
                        : null;
                    errors['password'] = passwordController.text.isEmpty
                        ? 'كلمة المرور مطلوبة'
                        : null;
                    errors['icon'] = cubit.selectedPasswordIcon == null
                        ? 'يجب اختيار أيقونة'
                        : null;
                    errors['category'] =
                        (cubit.selectedCategory?.isEmpty ?? true)
                        ? 'يجب اختيار فئة'
                        : null;
                  });

                  if (errors.values.any((e) => e != null)) return;

                  if (isEditMode) {
                    await cubit.updatePassword(
                      id: widget.existingPassword!.id,
                      service: serviceController.text.trim(),
                      email: emailController.text.trim(),
                      username: usernameController.text.trim(),
                      password: passwordController.text.trim(),
                      passwordIcon: cubit.selectedPasswordIcon!,
                      category: cubit.selectedCategory,
                      categoryIcon:
                          cubit.categoryIcons[cubit.selectedCategory]!,
                      note: noteController.text.trim(),
                    );
                  } else {
                    await cubit.savePassword(
                      service: serviceController.text.trim(),
                      email: emailController.text.trim(),
                      username: usernameController.text.trim(),
                      password: passwordController.text.trim(),
                      passwordIcon: cubit.selectedPasswordIcon!,
                      category: cubit.selectedCategory,
                      categoryIcon:
                          cubit.categoryIcons[cubit.selectedCategory]!,
                      note: noteController.text.trim(),
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(
                  isEditMode ? "تعديل" : "حفظ",
                  style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    String? keyName, {
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium!.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            filled: true,
            fillColor: colorScheme.surface.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (keyName != null && errors[keyName] != null)
          Text(errors[keyName]!, style: _errorStyle()),
      ],
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    bool isVisible,
    VoidCallback toggleVisibility,
    String keyName,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: !isVisible,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: "كلمة المرور",
            hintStyle: theme.textTheme.bodyMedium!.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            filled: true,
            fillColor: colorScheme.surface.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: colorScheme.onSurface,
              ),
              onPressed: toggleVisibility,
            ),
          ),
        ),
        if (errors[keyName] != null)
          Text(errors[keyName]!, style: _errorStyle()),
      ],
    );
  }

  TextStyle _errorStyle() => const TextStyle(color: Colors.red, fontSize: 12);

  InputDecoration _dropdownDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      filled: true,
      fillColor: colorScheme.surface.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
