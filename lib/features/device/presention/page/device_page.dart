import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakeyAi/features/device/presention/components/test_device.dart';
import 'package:wakeyAi/services/navigation_service.dart';
import '/features/auth/presention/auth_state.dart';
import '/features/device/presention/device_cubit.dart';

import '../../../auth/presention/auth_cubit.dart';
import '../components/connect_device.dart';
import '../device_state.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocBuilder<DeviceCubit, DeviceState>(builder: (context, state) {
        if (state is DeviceStatusLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is DeviceNotPair) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You Have No Devices Connected'),
                const SizedBox(height: 8),
                ConnectDevice(),
              ],
            ),
          );
        }

        if (state is DeviceConnected || state is DeviceDisconnected) {
          final deviceId =
              (context.read<AuthCubit>().state as Authenticated).user.deviceId;
          return Column(
            children: [
              SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.devices,
                      size: 42,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "WakeyAI Deivce",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          deviceId ?? "No Device Paired",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Icon(
                      state is DeviceConnected ? Icons.wifi : Icons.wifi_off,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 26,
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () => NavigationService.navigateTo(TestDevice(
                      deviceId: deviceId!,
                    )),
                    child: Text(
                      "Test Device",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () => context.read<DeviceCubit>().unpairDevice(),
                    child: Text(
                      "Unpair Device",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
