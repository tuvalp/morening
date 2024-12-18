import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '/services/navigation_service.dart';
import '../components/auth_button.dart';
import 'confirm_screen.dart';

class TermsScreen extends StatefulWidget {
  final String id;
  final String email;
  final String name;
  final String password;

  const TermsScreen({
    super.key,
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  String fileContent = "";
  bool isAgree = false;

  @override
  void initState() {
    super.initState();
    _loadTxtFile();
  }

  /// Loads the terms and conditions file from assets.
  Future<void> _loadTxtFile() async {
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

  /// Handles the navigation to the confirmation screen.
  void _navigateToConfirmScreen() {
    NavigationService.navigateTo(
      ConfirmScreen(
        id: widget.id,
        email: widget.email,
        name: widget.name,
        password: widget.password,
      ),
      replace: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 62),
              _buildHeader(context),
              const SizedBox(height: 62),
              _buildTermsContent(),
              const SizedBox(height: 32),
              AuthButton(
                text: 'Continue',
                onPressed: isAgree ? _navigateToConfirmScreen : null,
                disabled: !isAgree,
              ),
              const SizedBox(height: 62),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the header section with the app name and welcome text.
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

  /// Builds the terms and conditions content.
  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
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
              style: const TextStyle(
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
              onChanged: (value) {
                setState(() {
                  isAgree = value ?? false;
                });
              },
            ),
            const Flexible(
              child: Text(
                'I agree to the terms and conditions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
