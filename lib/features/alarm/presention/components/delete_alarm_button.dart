import 'package:flutter/material.dart';

class DeleteAlarmButton extends StatelessWidget {
  final void Function() onDelete;

  const DeleteAlarmButton({required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () => onDelete(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFFFF4C4C),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Center(
              child: Text(
                "Remove Alarm",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
