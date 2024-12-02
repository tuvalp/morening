import 'package:flutter/material.dart';

import '../components/auth_button.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Terms and Conditions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Text(
                      'By continuing, you agree to the terms and conditions of MoreNing. If you do not agree to these terms, please do not continue to use our app.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(value: false, onChanged: (v) => ()),
                    const Text(
                      'I agree to the terms and conditions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            AuthButton(
              text: 'Continue',
              onPressed: () => (),
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 62),
          ],
        ),
      ),
    );
  }
}
