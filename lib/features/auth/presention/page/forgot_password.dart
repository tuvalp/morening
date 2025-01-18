import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/navigation_service.dart';
import '/utils/snackbar_extension.dart';
import '/features/auth/presention/components/auth_textfield.dart';
import '../auth_cubit.dart';
import '../components/auth_button.dart';
import 'login_screen.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? email;
  String? password;
  String? confirmCode;
  String? confirmPassword;
  bool isCodeSant = false;

  void _navigateToLogin() {
    NavigationService.navigateTo(const LoginScreen(), replace: true);
  }

  void sendCode() async {
    if (emailController.text.isNotEmpty) {
      showLoadingDialog();
      isCodeSant = await context
          .read<AuthCubit>()
          .sendRestPassword(emailController.text);

      setState(() {
        email = emailController.text;
        isCodeSant;
        Navigator.of(context).pop();
      });
    } else {
      context.showErrorSnackBar("Place enter your email");
    }
  }

  void setCode() {
    if (confirmController.text.isNotEmpty) {
      setState(() {
        confirmCode = confirmController.text;
      });
    } else {
      context.showErrorSnackBar("Place enter a Confirmetion code");
    }
  }

  void resetPassword() async {
    if (passwordController.text == confirmPasswordController.text) {
      password = passwordController.text;
      showLoadingDialog();

      final isSacsses = await context
          .read<AuthCubit>()
          .resetPassword(email!, confirmCode!, password!);

      Navigator.of(context).pop();
      if (isSacsses) {
        context.showErrorSnackBar("Password is changed successfully");
        NavigationService.navigateTo(LoginScreen(), replace: true);
      }
    } else {
      context.showErrorSnackBar("Passwords do not match");
    }
  }

  @override
  void dispose() {
    confirmController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
            confirmCode != ""
                ? _buildSetPassword()
                : isCodeSant
                    ? _buildEnterCode()
                    : _buildSendCode(),
            _buildLoginLink(context),
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
          height: 70,
        ),
      ],
    );
  }

  Widget _buildSendCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Please enter your Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        AuthTextfield(
          controller: emailController,
          labelText: 'Email',
          obscureText: false,
        ),
        SizedBox(height: 32),
        AuthButton(
          text: "Send",
          onPressed: () => sendCode(),
        )
      ],
    );
  }

  Widget _buildEnterCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Confirmation Code was sant to',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '"$email"',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        AuthTextfield(
          controller: confirmController,
          labelText: 'Confirmation Code',
          obscureText: false,
        ),
        SizedBox(height: 8),
        TextButton(
          child: Text(
            "Enter Diffrent Email",
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () => setState(() {
            email = null;
            isCodeSant = false;
          }),
        ),
        SizedBox(height: 32),
        AuthButton(
          text: "Continue",
          onPressed: () => setCode(),
        )
      ],
    );
  }

  Widget _buildSetPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Choose a new password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        AuthTextfield(
          controller: passwordController,
          labelText: 'Password',
          obscureText: true,
        ),
        SizedBox(height: 8),
        AuthTextfield(
          controller: confirmPasswordController,
          labelText: 'Confirm Password',
          obscureText: true,
        ),
        SizedBox(height: 32),
        AuthButton(
          text: "Reset Password",
          onPressed: () => resetPassword(),
        )
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToLogin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Go back to',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            "Login",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
}
