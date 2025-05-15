import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  void showSplashDialog(context) {
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
                'WakeyAi',
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
