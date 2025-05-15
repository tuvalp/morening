import 'package:flutter/material.dart';

class AuthTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final IconButton? suffixIcon;

  const AuthTextfield({
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.suffixIcon,
    super.key,
  });

  @override
  State<AuthTextfield> createState() => _AuthTextfieldState();
}

class _AuthTextfieldState extends State<AuthTextfield> {
  bool _isHidden = false;

  @override
  void initState() {
    super.initState();
    _isHidden = widget.obscureText;
  }

  void _toggleHidden() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _isHidden,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => _toggleHidden(),
                )
              : null,
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
          hintText: widget.labelText,
        ),
      ),
    );
  }
}
