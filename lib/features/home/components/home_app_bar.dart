import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../device/presention/device_cubit.dart';

import '../../../services/navigation_service.dart';
import '../../device/presention/page/device_page.dart';
import '../../profile/presention/pages/profile_screen.dart';
import '../../device/presention/device_state.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceCubit, DeviceState>(
      builder: (context, state) {
        return AppBar(
          title: Image.asset(
            "assets/logo/logo.png",
            height: 40,
            scale: 1,
          ),

          //  const Text(
          //   'Morening',
          //   style: TextStyle(fontWeight: FontWeight.w600),
          // ),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.account_circle),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () {
              NavigationService.navigateTo(const ProfileScreen());
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                switch (state) {
                  DeviceConnected() => Icons.wifi,
                  DeviceDisconnected() => Icons.wifi_off,
                  DeviceNotPair() => Icons.devices,
                  DeviceStatusError() => Icons.error,
                  DeviceStatusLoading() => Icons.hourglass_empty,
                  _ => Icons.help_outline,
                },
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                NavigationService.navigateTo(
                  DevicePage(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
