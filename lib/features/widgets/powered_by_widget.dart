import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoweredByWidget extends StatelessWidget {
  const PoweredByWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/app_icon.png', width: 16.r, height: 16.r),
          SizedBox(width: 8.w),
          Text(
            'Powered by Muhammad',
            style: TextStyle(
              fontSize: 8.sp,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
