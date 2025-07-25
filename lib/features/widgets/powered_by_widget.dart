import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';

class PoweredByWidget extends StatelessWidget {
  const PoweredByWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/app_icon.png', width: 16.r, height: 16.r),
          const SizedBox(width: 8),
          Text(
            'Powered by Muhammad',
            style: TextStyle(fontSize: 8.sp, color: AppColors.titleText),
          ),
        ],
      ),
    );
  }
}
