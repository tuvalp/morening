import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app.dart';
import '../auth_cubit.dart';
import '../auth_state.dart';
import '../components/auth_button.dart';
import '../components/auth_textfield.dart';
import '/../services/navigation_service.dart';
import '/../utils/snackbar_extension.dart';
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

    context.read<AuthCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthError ||
            current is AuthLoading ||
            current is Authenticated,
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else if (state is AuthError) {
            setState(() => _isLoading = false);
            context.showErrorSnackBar(state.error);
          } else if (state is Authenticated) {
            setState(() => _isLoading = false);
            NavigationService.navigateTo(const AppView(), replace: true);
          }
        },
        buildWhen: (previous, current) => current is AuthLoading,
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 62),
                        _buildHeader(context),
                        const SizedBox(height: 62),
                        _buildInputFields(),
                        const SizedBox(height: 32),
                        AuthButton(
                          text: 'Login',
                          onPressed: _isLoading ? null : _login,
                        ),
                        const SizedBox(height: 32),
                        _buildRegisterLink(context),
                        const SizedBox(height: 62),
                      ],
                    ),
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

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

  Widget _buildInputFields() {
    return Column(
      children: [
        AuthTextfield(
          controller: emailController,
          obscureText: false,
          labelText: 'Email',
        ),
        const SizedBox(height: 16),
        AuthTextfield(
          controller: passwordController,
          obscureText: true,
          labelText: 'Password',
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
