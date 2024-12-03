import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:morening_2/features/auth/presention/page/confirm_screen.dart';
import '../components/auth_button.dart';

class TermsScreen extends StatefulWidget {
  final String email;
  const TermsScreen({super.key, required this.email});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  String fileContent = "";
  bool isAgree = false;

  @override
  void initState() {
    super.initState();
    loadTxtFile();
  }

  Future<void> loadTxtFile() async {
    try {
      final content =
          await rootBundle.loadString('assets/terms_of_agreement.txt');
      setState(() {
        fileContent = content;
      });
    } catch (e) {
      setState(() {
        fileContent = "Failed to load the file: $e";
      });
    }
  }

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
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Text(
                      fileContent,
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
                    Checkbox(
                      value: isAgree,
                      onChanged: (value) => (setState(() {
                        isAgree = value!;
                      })),
                    ),
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
              onPressed: () {
                if (isAgree) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmScreen(email: widget.email),
                    ),
                  );
                }
              },
              disabled: !isAgree,
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 62),
          ],
        ),
      ),
    );
  }
}
