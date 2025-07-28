import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import '../cubit/home_cubit.dart';

class HomeHeaderWidget extends StatelessWidget {
  final VoidCallback onAddPressed;

  const HomeHeaderWidget({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(32.r),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "كلمات السر الخاصة بك",
                style: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onAddPressed,
                    icon: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: colorScheme.primary.withOpacity(0.9),
                      ),
                      child: Icon(Icons.add, color: colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // شريط البحث
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final showSearch = context.read<HomeCubit>().isSearchVisible;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) =>
                  SizeTransition(sizeFactor: anim, child: child),
              child: showSearch
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: colorScheme.onSurface.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: textTheme.bodyMedium!.copyWith(
                                color: colorScheme.onSurface,
                              ),
                              cursorColor: colorScheme.primary,
                              decoration: InputDecoration(
                                hintText: "ابحث عن كلمة سر...",
                                hintStyle: textTheme.bodyMedium!.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                filled: false,
                                isCollapsed: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }
}
