import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/auth/domain/models/app_user.dart';

import '../../../services/navigation_service.dart';
import '../../auth/presention/auth_cubit.dart';
import '../../auth/presention/auth_state.dart';
import '../../device/presention/page/device_page.dart';
import '../../profile/presention/pages/profile_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    AppUser? user;
    AuthState authCubit = context.watch<AuthState>();
    if (authCubit is Authenticated) {
      user = authCubit.user;
    }

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
          icon: user!.deviceId != null
              ? const Icon(Icons.wifi)
              : const Icon(Icons.devices),
          onPressed: () {
            NavigationService.navigateTo(const DevicePage());
          },
        )
      ],
    );
  }
}
