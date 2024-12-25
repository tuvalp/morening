import 'package:flutter/material.dart';

class QuestionButton extends StatelessWidget {
  const QuestionButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isSelected = false,
  });

  final void Function()? onPressed;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed!(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(100),
          // border: Border.all(
          //   color: isSelected
          //       ? Theme.of(context).colorScheme.primary
          //       : Theme.of(context).colorScheme.onTertiary,
          //   width: 2,
          // ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Stack(children: [
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              isSelected ? Icons.circle : Icons.circle_outlined,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
