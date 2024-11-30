import 'package:flutter/material.dart';

import '../../../alarm/presention/page/add_edit_alarm_view.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const MainAppBar({this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title != null ? title! : "MoreNing",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: title != null
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEditAlarmView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.wifi,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
