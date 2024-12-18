import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/auth/presention/page/wake_up_qustion.dart';

import '/services/navigation_service.dart';
import '/utils/snackbar_extension.dart';
import '/features/auth/presention/components/auth_textfield.dart';
import '../auth_cubit.dart';
import '../auth_state.dart';
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

    context.read<AuthCubit>().confirmUser(confirmationCode, widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOnConfirm) {
          NavigationService.navigateTo(
            WakeUpQuestionScreen(
              id: widget.id,
              email: widget.email,
              name: widget.name,
              password: widget.password,
            ),
            replace: true,
          );
        } else if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 62),
                _buildHeader(context),
                const SizedBox(height: 62),
                _buildConfirmationInput(),
                const SizedBox(height: 32),
                AuthButton(
                  text: 'Continue',
                  onPressed: _confirm,
                ),
                const SizedBox(height: 62),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the header with the app name and welcome message.
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'MoreNing',
          style: TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Text(
          'Welcome to MoreNing',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
