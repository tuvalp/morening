import 'package:flutter/material.dart';
import 'package:morening_2/features/device/presention/components/connect_deivce.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You Have No Devices Connected'),
            const SizedBox(height: 8),
            ConnectDeivce(),
          ],
        ),
      ),
    );
  }
}
