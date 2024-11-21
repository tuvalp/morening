import 'package:flutter/material.dart';

import '../../../alarm/presention/page/add_edit_alarm_view.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const MainAppBar({this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(title != null ? title! : "MoreNing",
          style: const TextStyle(fontSize: 24, letterSpacing: 1.5)),
      leading: IconButton(
        icon: const Icon(Icons.add_circle),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditAlarmView()),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.wifi),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
