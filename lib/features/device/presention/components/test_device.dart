import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakeyAi/features/device/presention/device_cubit.dart';

class TestDevice extends StatefulWidget {
  final String deviceId;
  const TestDevice({required this.deviceId, super.key});

  @override
  State<TestDevice> createState() => _TestDeviceState();
}

class _TestDeviceState extends State<TestDevice> {
  double lightVolume = 1;
  double lightDuration = 5;
  double smellVolume = 1;
  double smellDuration = 5;
  double speakerVolume = 1;
  double speakerDuration = 5;

  void updateVolume(String section, double value) {
    setState(() {
      switch (section) {
        case "Light":
          lightVolume = value;
          break;
        case "Smell":
          smellVolume = value;
          break;
        case "Speaker":
          speakerVolume = value;
          break;
      }
    });
  }

  void updateDuration(String section, bool increase) {
    setState(() {
      switch (section) {
        case "Light":
          lightDuration = increase
              ? lightDuration + 1
              : (lightDuration > 1 ? lightDuration - 1 : lightDuration);
          break;
        case "Smell":
          smellDuration = increase
              ? smellDuration + 1
              : (smellDuration > 1 ? smellDuration - 1 : smellDuration);
          break;
        case "Speaker":
          speakerDuration = increase
              ? speakerDuration + 1
              : (speakerDuration > 1 ? speakerDuration - 1 : speakerDuration);
          break;
      }
    });
  }

  void test(String section) {
    switch (section) {
      case "Light":
        context
            .read<DeviceCubit>()
            .testDevice(widget.deviceId, "light", lightVolume, lightDuration);
        break;
      case "Smell":
        context
            .read<DeviceCubit>()
            .testDevice(widget.deviceId, "smell", smellVolume, smellDuration);
        break;
      case "Speaker":
        context.read<DeviceCubit>().testDevice(
            widget.deviceId, "speaker", speakerVolume, speakerDuration);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Test Device'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _TestSection(
              title: "Light",
              volume: lightVolume,
              duration: lightDuration,
              onVolumeChanged: (value) => updateVolume("Light", value),
              onDurationChanged: (increase) =>
                  updateDuration("Light", increase),
              onTestPressed: () {
                test("Light");
              },
            ),
            _TestSection(
              title: "Speaker",
              volume: speakerVolume,
              duration: speakerDuration,
              onVolumeChanged: (value) => updateVolume("Speaker", value),
              onDurationChanged: (increase) =>
                  updateDuration("Speaker", increase),
              onTestPressed: () {
                test("Speaker");
              },
            ),
            _TestSection(
              title: "Smell",
              volume: smellVolume,
              duration: smellDuration,
              onVolumeChanged: (value) => updateVolume("Smell", value),
              onDurationChanged: (increase) =>
                  updateDuration("Smell", increase),
              onTestPressed: () {
                test("Smell");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TestSection extends StatelessWidget {
  final String title;
  final double volume;
  final double duration;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<bool> onDurationChanged;
  final VoidCallback onTestPressed;

  const _TestSection({
    required this.title,
    required this.volume,
    required this.duration,
    required this.onVolumeChanged,
    required this.onDurationChanged,
    required this.onTestPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(onPressed: onTestPressed, child: const Text("Test")),
            ],
          ),
          const SizedBox(height: 8),
          const Text("Volume", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 2),
          Slider(
            value: volume,
            min: 0,
            max: 1,
            divisions: 10,
            onChanged: onVolumeChanged,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text("Duration", style: TextStyle(fontSize: 14)),
              const Spacer(),
              IconButton(
                onPressed: () => onDurationChanged(false),
                icon: const Icon(Icons.remove_circle),
              ),
              Text(duration.toStringAsFixed(0)),
              IconButton(
                onPressed: () => onDurationChanged(true),
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
