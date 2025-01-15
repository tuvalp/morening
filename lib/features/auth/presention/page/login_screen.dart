import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/utils/splash_extension.dart';

import '../../../home/pages/home_view.dart';
import '../auth_cubit.dart';
import '../auth_state.dart';
import '../components/auth_button.dart';
import '../components/auth_textfield.dart';
import '/../services/navigation_service.dart';
import '/../utils/snackbar_extension.dart';
import 'forgot_password.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      context.showErrorSnackBar("Please fill all the fields");
      return;
    }
    context.showSplashDialog(context);

    context.read<AuthCubit>().login(email, password).then((success) {
      if (success) {
        Navigator.of(context).pop();
        NavigationService.navigateTo(const HomeView(), replace: true);
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          NavigationService.navigateTo(const HomeView(), replace: true);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 76),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader(),
              _buildInputFields(),
              _buildRegisterLink(context),
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

  Widget _buildInputFields() {
    return Column(
      children: [
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
        const SizedBox(height: 16),
        AuthButton(
          text: 'Login',
          onPressed: _isLoading ? null : _login,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            NavigationService.navigateTo(const ForgotPasswordView(),
                replace: true);
          },
          child: const Text('Forgot Password?', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.navigateTo(const RegisterScreen(), replace: true);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Don\'t have an account?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "Register",
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
