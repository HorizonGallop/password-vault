import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Authentication Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
