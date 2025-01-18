import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../services/navigation_service.dart';
import '/utils/snackbar_extension.dart';

import '../auth_cubit.dart';
import '../components/auth_button.dart';
import '../components/auth_textfield.dart';
import 'login_screen.dart';
import 'terms_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      context.showErrorSnackBar("Please fill all the fields");
      return;
    }

    if (password != confirmPassword) {
      context.showErrorSnackBar("Passwords do not match");
      return;
    }

    showLoadingDialog();

    context.read<AuthCubit>().register(email, password, name).then((id) {
      if (id != null) {
        Navigator.of(context).pop();
        NavigationService.navigateTo(
          TermsScreen(
            id: id,
            email: email,
            name: name,
            password: password,
          ),
          replace: true,
        );
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  void _navigateToLogin() {
    NavigationService.navigateTo(const LoginScreen(), replace: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 68.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader(),
              SingleChildScrollView(
                child: _buildInputFields(),
              ),
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: _buildLoginLink(context),
              ),
            ],
          ),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/logo/logo.png',
          height: 70,
        ),
      ],
    );
  }

  /// Builds the input fields for registration.
  Widget _buildInputFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AuthTextfield(
          controller: nameController,
          obscureText: false,
          labelText: 'Full Name',
        ),
        AuthTextfield(
          controller: emailController,
          obscureText: false,
          labelText: 'Email',
        ),
        AuthTextfield(
          controller: passwordController,
          obscureText: true,
          labelText: 'Password',
        ),
        SizedBox(height: 4),
        Text(
          'At least 8 characters long, contain at least one uppercase letter and one special character',
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        SizedBox(height: 12),
        AuthTextfield(
          controller: confirmPasswordController,
          obscureText: true,
          labelText: 'Confirm Password',
        ),
        const SizedBox(height: 16),
        AuthButton(
          text: 'Register',
          onPressed: _register,
        ),
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
            'Already have an account?',
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
}
