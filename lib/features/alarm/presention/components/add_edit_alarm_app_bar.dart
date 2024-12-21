import 'package:flutter/material.dart';
import 'package:morening_2/services/navigation_service.dart';

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        title,
      ),
      centerTitle: true,
      leadingWidth: 60,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          NavigationService.pop();
        },
      ),
      actions: [
        TextButton(
          onPressed: onSave,
          child: Text(
            "Done",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
