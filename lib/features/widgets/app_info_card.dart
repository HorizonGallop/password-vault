import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInfoCard extends StatefulWidget {
  final String title;
  final String subtitle; // النص الأصلي (الحقيقي)
  final IconData icon;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool copyable;
  final bool isPassword;
  final bool isSensitive;

  const AppInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.trailing,
    this.onTap,
    this.copyable = false,
    this.isPassword = false,
    this.isSensitive = false,
  });

  @override
  State<AppInfoCard> createState() => _AppInfoCardState();
}

class _AppInfoCardState extends State<AppInfoCard> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final bool hideContent = widget.isPassword || widget.isSensitive;

    return GestureDetector(
      onTap: widget.onTap,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: widget.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 28.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  SelectableText(
                    hideContent
                        ? (_isVisible ? widget.subtitle : '••••••••')
                        : widget.subtitle,
                    style: textTheme.bodyLarge?.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            if (hideContent)
              IconButton(
                icon: Icon(
                  _isVisible ? Icons.visibility_off : Icons.visibility,
                  size: 20.sp,
                  color: theme.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _isVisible = !_isVisible;
                  });
                },
              ),
            if (widget.copyable)
              IconButton(
                icon: Icon(Icons.copy, size: 20.sp, color: theme.primaryColor),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: widget.subtitle, // ✅ النسخ دايمًا القيمة الحقيقية
                    ),
                  );
                  _showCopyFeedback(context, widget.title);
                },
              ),
            widget.trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _showCopyFeedback(BuildContext context, String field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$field تم نسخه!"),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
