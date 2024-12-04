import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void register() {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        context.read<AuthCubit>().register(email, password, name);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            showCloseIcon: true,
            content: Text("Passwords do not match"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          content: Text("Please fill all the fields"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOnRegister) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TermsScreen(email: emailController.text),
            ),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 62),
                Column(
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
                      'let\'s get started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 62),
                Column(
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
                ),
                const SizedBox(height: 32),
                AuthButton(
                  text: 'Register',
                  onPressed: register,
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
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
                ),
                const SizedBox(height: 62),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
