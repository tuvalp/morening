import 'package:flutter/material.dart';

class AddEditAlarmAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSave;

  const AddEditAlarmAppBar({
    super.key,
    required this.title,
    required this.onSave,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      shadowColor: Colors.transparent,
      title: Text(title),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        TextButton(
          onPressed: onSave,
          child: const Text(
            "Done",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
