import 'package:flutter/material.dart';

import '../../../services/navigation_service.dart';
import '../../device/presention/components/wifi_conect.dart';
import '../../device/presention/page/device_page.dart';
import '../../profile/presention/pages/profile_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          const Text('Morening', style: TextStyle(fontWeight: FontWeight.w600)),
      centerTitle: true,
      foregroundColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          NavigationService.navigateTo(const ProfileScreen());
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.wifi),
          onPressed: () {
            NavigationService.navigateTo(WifiListScreen());
          },
        ),
      ],
    );
  }
}
