import 'package:flutter/material.dart';

class AuthTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  const AuthTextfield({
    required this.controller,
    required this.labelText,
    required this.obscureText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              width: 1,
              style: BorderStyle.solid,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              width: 1,
              style: BorderStyle.solid,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          hintText: labelText,
        ),
      ),
    );
  }
}
