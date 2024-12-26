import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '/features/auth/presention/components/auth_button.dart';
import '/features/auth/presention/components/auth_textfield.dart';

class ConnectDeivce extends StatelessWidget {
  const ConnectDeivce({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => const ConnectDeivceSheet(),
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
        );
      },
      child: Text(
        'Connect Device',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ConnectDeivceSheet extends StatefulWidget {
  const ConnectDeivceSheet({super.key});

  @override
  State<ConnectDeivceSheet> createState() => _ConnectDeivceSheetState();
}

class _ConnectDeivceSheetState extends State<ConnectDeivceSheet> {
  final bool isConected = false;

  final TextEditingController passwordController = TextEditingController();
  String ssid = "";

  selectSsid(String selectedSsid) {
    setState(() {
      ssid = selectedSsid;
    });
  }

  void connectToMorningDevice() async {
    if (await Permission.location.request().isGranted) {
      try {
        WiFiForIoTPlugin.connect("morenning", password: "12345678")
            .then((value) => print(value));
      } catch (e) {
        print('Error loading Wi-Fi list: $e');
      }
    }
  }

  @override
  void initState() {
    connectToMorningDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      child: ssid.isEmpty ? _selectNetwork() : _setNetworkPassword(),
    );
  }

  Widget _connectMoreningDevice() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Search for Nearby Morning Device",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _selectNetwork() {
    return Column(
      children: [
        Text(
          "Connect The Deivce To Your Home Network",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 50),
        Expanded(
          child: ListView(
            children: [
              for (int i = 0; i < 8; i++)
                ListTile(
                  leading: Icon(Icons.wifi),
                  title: Text("Network $i"),
                  onTap: () {
                    selectSsid("Network $i");
                  },
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget _setNetworkPassword() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Connect The Deivce To Your Home Network",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        AuthTextfield(
          controller: passwordController,
          labelText: "Password",
          obscureText: true,
        ),
        Column(
          children: [
            AuthButton(text: "Connect", onPressed: () {}),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  ssid = "";
                });
              },
              child: const Text("Select Another Network"),
            )
          ],
        )
      ],
    );
  }

  Widget _connectSuccess() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Morning Device Connected",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
          Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
