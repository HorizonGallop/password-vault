import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_cubit.dart';

void showSignOutDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        "تأكيد تسجيل الخروج",
        style: TextStyle(color: colorScheme.onSurface),
      ),
      content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
      actions: [
        TextButton(
          child: Text("إلغاء", style: TextStyle(color: colorScheme.primary)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
            context.read<ProfileCubit>().signOut();
          },
          child: const Text("تسجيل الخروج"),
        ),
      ],
    ),
  );
}

void showDeleteAccountDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        "⚠️ حذف الحساب نهائيًا",
        style: TextStyle(color: colorScheme.error),
      ),
      content: Text(
        "هل أنت متأكد؟ سيتم حذف جميع البيانات نهائيًا ولا يمكن استعادتها.",
      ),
      actions: [
        TextButton(
          child: Text("إلغاء", style: TextStyle(color: colorScheme.primary)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          onPressed: () {
            Navigator.pop(context);
            _askForMasterPassword(context);
          },
          child: const Text("استمرار"),
        ),
      ],
    ),
  );
}

void _askForMasterPassword(BuildContext mainContext) {
  final colorScheme = Theme.of(mainContext).colorScheme;
  final controller = TextEditingController();
  bool isWrongPassword = false;
  bool isLoading = false;

  showDialog(
    context: mainContext,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final isButtonActive =
              controller.text.trim().isNotEmpty && !isLoading;

          return AlertDialog(
            backgroundColor: colorScheme.surface,
            title: Text(
              "أدخل الماستر باسورد",
              style: TextStyle(color: colorScheme.onSurface),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "الماستر باسورد",
                    errorText: isWrongPassword ? "كلمة المرور غير صحيحة" : null,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  "إلغاء",
                  style: TextStyle(color: colorScheme.primary),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonActive
                      ? colorScheme.primary
                      : colorScheme.primary.withOpacity(0.5),
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: isButtonActive
                    ? () async {
                        setState(() {
                          isLoading = true;
                          isWrongPassword = false;
                        });

                        final isValid = await mainContext
                            .read<ProfileCubit>()
                            .verifyMasterPassword(controller.text.trim());

                        if (isValid) {
                          Navigator.pop(context);
                          _finalDeleteConfirmation(
                            mainContext,
                            controller.text.trim(),
                          );
                        } else {
                          setState(() {
                            isWrongPassword = true;
                            isLoading = false;
                          });
                        }
                      }
                    : null,
                child: isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("تأكيد"),
              ),
            ],
          );
        },
      );
    },
  );
}

void _finalDeleteConfirmation(BuildContext context, String masterPassword) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text("تأكيد نهائي", style: TextStyle(color: colorScheme.error)),
      content: const Text(
        "هل تريد بالتأكيد حذف الحساب وجميع البيانات المرتبطة به؟ لا يمكن التراجع.",
      ),
      actions: [
        TextButton(
          child: Text("إلغاء", style: TextStyle(color: colorScheme.primary)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          onPressed: () {
            Navigator.pop(context);
            context.read<ProfileCubit>().deleteAccountNow(masterPassword);
          },
          child: const Text("حذف الآن"),
        ),
      ],
    ),
  );
}
