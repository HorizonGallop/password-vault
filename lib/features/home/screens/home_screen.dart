import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pswrd_vault/features/home/screens/password_screen.dart';
import 'package:pswrd_vault/features/home/widgets/password_form_dialog.dart';
import 'package:pswrd_vault/features/home/widgets/header_widget.dart';
import '../cubit/home_cubit.dart';
import '../widgets/category_card.dart';
import '../widgets/password_card.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home-screen';
  final String masterPassword;

  const HomeScreen({super.key, required this.masterPassword});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) =>
          HomeCubit(masterPassword: masterPassword)..listenPasswords(),
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomePasswordSaved) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('تمت الإضافة بنجاح')));
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: colorScheme.background,
            body: Column(
              children: [
                HomeHeaderWidget(
                  onAddPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (sheetContext) {
                        final homeCubit = context.read<HomeCubit>();
                        return PasswordFormDialog(homeCubit: homeCubit);
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) =>
                        current is HomePasswordsLoaded ||
                        current is HomeCategoriesUpdated ||
                        current is HomeLoading ||
                        current is HomeError,
                    builder: (context, state) {
                      final cubit = context.read<HomeCubit>();

                      if (state is HomeLoading) {
                        return Center(
                          child: Lottie.asset(
                            'assets/lottie/loading.json',
                            width: 150,
                          ),
                        );
                      } else if (state is HomeError) {
                        return Center(child: Text(state.message));
                      }

                      // في حال البحث فارغ أو لا يوجد كلمات سر مفلترة، نعرض الفئات مع كلمات السر
                      final passwords = cubit.passwords;

                      if (passwords.isEmpty) {
                        return const Center(
                          child: Text(
                            "لا توجد أي كلمات مرور مضافة بعد",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }

                      // تجميع كلمات السر حسب الفئة
                      final groupedPasswords = <String, List<PasswordCard>>{};
                      for (var pwd in passwords) {
                        final category = pwd.category;
                        groupedPasswords.putIfAbsent(category, () => []);
                        groupedPasswords[category]!.add(
                          PasswordCard(
                            serviceName: pwd.service,
                            username: pwd.username,
                            description: pwd.note ?? '',
                            icon: Icons.lock,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<HomeCubit>(),
                                    child: PasswordDetailsScreen(
                                      passwordModel: pwd,
                                      masterPassword: masterPassword,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: groupedPasswords.entries.map((entry) {
                          final category = entry.key;
                          final cards = entry.value;

                          return KeyedSubtree(
                            key: ValueKey('section_$category'),
                            child: _buildCategorySection(
                              context,
                              category,
                              cubit.categoryIcons[category] ?? Icons.more_horiz,
                              cubit.expandedCategories[category] ?? false,
                              cards,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    IconData icon,
    bool isExpanded,
    List<Widget> passwords,
  ) {
    final cubit = context.read<HomeCubit>();

    return Column(
      key: ValueKey('category_$title'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryCard(
          key: ValueKey('card_$title'),
          title: title,
          icon: icon,
          isExpanded: isExpanded,
          onTap: () => cubit.toggleCategoryExpanded(title),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: isExpanded
                ? Padding(
                    key: ValueKey('expanded_$title'),
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 8,
                      bottom: 16,
                    ),
                    child: SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            SizedBox(width: 220, child: passwords[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemCount: passwords.length,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
