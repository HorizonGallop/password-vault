import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_cubit.dart';
import 'package:pswrd_vault/features/profile/cubit/profile_state.dart';
import 'package:pswrd_vault/features/profile/widgets/profile_content.dart';
import 'package:pswrd_vault/features/widgets/loading_widget.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadUserProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is SignedOut) {
            Navigator.pushReplacementNamed(context, '/google-auth');
          } else if (state is AccountDeleted) {
            Navigator.pushReplacementNamed(context, '/onboarding');
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(body: Center(child: LoadingOverlay()));
          }

          return Scaffold(
            body: SafeArea(child: ProfileContent(state: state)),
          );
        },
      ),
    );
  }
}
