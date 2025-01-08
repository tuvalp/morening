import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/presention/auth_state.dart';
import '../../device/presention/device_cubit.dart';
import '/features/auth/domain/models/app_user.dart';

import '../../../services/navigation_service.dart';
import '../../auth/presention/auth_cubit.dart';
import '../../device/presention/page/device_page.dart';
import '../../profile/presention/pages/profile_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Access the AuthCubit state
    final authState = context.watch<AuthCubit>().state;
    AppUser? user;

    if (authState is Authenticated) {
      user = authState.user;
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
        if (user != null)
          BlocBuilder<DeviceCubit, DeviceState>(
            builder: (context, deviceState) {
              IconData icon;
              if (deviceState is DeviceStatus &&
                  deviceState.status == "Connected") {
                icon = Icons.wifi;
              } else if (deviceState is DeviceStatus &&
                  deviceState.status != "Connected") {
                icon = Icons.wifi_off;
              } else {
                icon = Icons.devices;
              }

              return IconButton(
                icon: Icon(icon),
                onPressed: () {
                  NavigationService.navigateTo(
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<DeviceCubit>(
                          create: (_) => DeviceCubit(user!),
                        ),
                      ],
                      child: const DevicePage(),
                    ),
                  );
                },
              );
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.devices),
            onPressed: () {},
          ),
      ],
    );
  }
}
