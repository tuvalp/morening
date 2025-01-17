import 'dart:async';

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
  int _remainingTime = 0; // Time in seconds
  Timer? _timer;

  @override
  void dispose() {
    confirmController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  /// Starts the countdown timer for resending the code.
  void _startResendTimer() {
    setState(() {
      _remainingTime = 60; // 60 seconds countdown
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

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
      Navigator.of(context).pop();
      if (success == true) {
        NavigationService.navigateTo(const HomeView(), replace: true);
      }
    });
  }

  void _resendConfirmationCode() {
    if (_remainingTime == 0) {
      context.read<AuthCubit>().resendConfirmationCode(widget.email);
      _startResendTimer();
    }
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

  Widget _buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/logo/logo.png',
          height: 140,
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
        const SizedBox(height: 32),
        TextButton(
          onPressed: _remainingTime == 0 ? _resendConfirmationCode : null,
          child: Text(
            _remainingTime == 0
                ? "Resend Code"
                : "Code resent, send again in $_remainingTime seconds",
            style: TextStyle(
              fontSize: 16,
              color: _remainingTime == 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ),
      ],
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
}
