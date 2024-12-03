import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/presention/components/auth_textfield.dart';
import '../../../../utils/format.dart';
import '../auth_cubit.dart';
import '../auth_state.dart';
import '../components/auth_button.dart';
import 'login_screen.dart';

class ConfirmScreen extends StatefulWidget {
  final String email;
  const ConfirmScreen({super.key, required this.email});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  TextEditingController confirmController = TextEditingController();

  void confirm() {
    if (confirmController.text.isNotEmpty) {
      context
          .read<AuthCubit>()
          .confirmUser(confirmController.text, widget.email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          content: Text("Please Enter Your Confirmation Code"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                showCloseIcon: true,
                content: Text(Format.extractMessage(state.error)),
              ),
            );
          } else if (state is AuthRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                showCloseIcon: true,
                content: Text("You Have Registered Successfully, Please Login"),
              ),
            );
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        },
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
                      'Welcome to MoreNing',
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
                    Text(
                      'Please Enter Your Confirmation Code',
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
                ),
                const SizedBox(height: 32),
                AuthButton(
                  text: 'Continue',
                  onPressed: () => confirm(),
                ),
                const SizedBox(height: 32),
                const SizedBox(height: 62),
              ],
            ),
          ),
        ));
  }
}
