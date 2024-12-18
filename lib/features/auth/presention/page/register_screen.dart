import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../services/navigation_service.dart';
import '/utils/snackbar_extension.dart';
import '/features/auth/presention/page/terms_screen.dart';

import '../auth_cubit.dart';
import '../auth_state.dart';
import '../components/auth_button.dart';
import '../components/auth_textfield.dart';
import 'login_screen.dart';

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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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

    context.read<AuthCubit>().register(email, password, name);
  }

  void _navigateToLogin() {
    NavigationService.navigateTo(const LoginScreen(), replace: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOnRegister) {
          NavigationService.navigateTo(
            TermsScreen(
              id: state.userId,
              email: emailController.text,
              name: nameController.text,
              password: passwordController.text,
            ),
            replace: true,
          );
        } else if (state is AuthError) {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          context.showErrorSnackBar(state.error);
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 62),
                _buildHeader(context),
                const SizedBox(height: 62),
                _buildInputFields(),
                const SizedBox(height: 32),
                AuthButton(
                  text: 'Register',
                  onPressed: _register,
                ),
                const SizedBox(height: 32),
                _buildLoginLink(context),
                const SizedBox(height: 62),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the header with the title and subtitle.
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
          'Let\'s get started',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds the input fields for registration.
  Widget _buildInputFields() {
    return Column(
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
        AuthTextfield(
          controller: confirmPasswordController,
          obscureText: true,
          labelText: 'Confirm Password',
        ),
      ],
    );
  }

  /// Builds the login link at the bottom.
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
          const SizedBox(width: 4),
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
