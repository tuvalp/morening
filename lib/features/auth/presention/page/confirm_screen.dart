import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/home/pages/home_view.dart';

import '../../../../services/navigation_service.dart';
import '/utils/snackbar_extension.dart';
import '/features/auth/presention/components/auth_textfield.dart';
import '../auth_cubit.dart';
import '../components/auth_button.dart';

class ConfirmScreen extends StatefulWidget {
  final String id;
  final String email;
  final String name;
  final String password;

  const ConfirmScreen({
    super.key,
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final TextEditingController confirmController = TextEditingController();

  @override
  void dispose() {
    confirmController.dispose();
    super.dispose();
  }

  /// Handles the confirmation logic.
  void _confirm() {
    final confirmationCode = confirmController.text.trim();

    if (confirmationCode.isEmpty) {
      context.showErrorSnackBar("Please enter your confirmation code");
      return;
    }
    showLoadingDialog();

    context
        .read<AuthCubit>()
        .confirmUser(
          confirmationCode,
          widget.id,
          widget.email,
          widget.password,
          widget.name,
        )
        .then((success) {
      if (success == true) {
        Navigator.of(context).pop();
        NavigationService.navigateTo(const HomeView(), replace: true);
      }
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 76.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(),
            _buildConfirmationInput(),
            AuthButton(
              text: 'Continue',
              onPressed: _confirm,
            ),
          ],
        ),
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black.withOpacity(0.3),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Morning',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          'Morning',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  /// Builds the confirmation code input section.
  Widget _buildConfirmationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Please enter your confirmation code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        AuthTextfield(
          controller: confirmController,
          labelText: 'Confirmation Code',
          obscureText: false,
        ),
      ],
    );
  }
}
