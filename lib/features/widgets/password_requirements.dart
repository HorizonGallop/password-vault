import 'package:flutter/material.dart';

class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final List<_Requirement> requirements = [
      _Requirement(
        label: "At least 8 characters",
        isMet: password.length >= 8,
      ),
      _Requirement(
        label: "At least one uppercase letter",
        isMet: password.contains(RegExp(r'[A-Z]')),
      ),
      _Requirement(
        label: "At least one lowercase letter",
        isMet: password.contains(RegExp(r'[a-z]')),
      ),
      _Requirement(
        label: "At least one number",
        isMet: password.contains(RegExp(r'[0-9]')),
      ),
      _Requirement(
        label: "At least one special character (!@#\$%^&*)",
        isMet: password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements.map((req) {
        return Row(
          children: [
            Icon(
              req.isMet ? Icons.check_circle : Icons.cancel,
              color: req.isMet ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              req.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                decoration:
                    req.isMet ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _Requirement {
  final String label;
  final bool isMet;

  _Requirement({required this.label, required this.isMet});
}
