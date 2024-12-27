import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:morening_2/services/api_service.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '/features/auth/presention/components/auth_button.dart';
import '/features/auth/presention/components/auth_textfield.dart';

class ConnectDevice extends StatelessWidget {
  const ConnectDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => const ConnectDeviceSheet(),
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

class ConnectDeviceSheet extends StatefulWidget {
  const ConnectDeviceSheet({super.key});

  @override
  State<ConnectDeviceSheet> createState() => _ConnectDeviceSheetState();
}

class _ConnectDeviceSheetState extends State<ConnectDeviceSheet> {
  bool _isConnected = false;
  String? _connectionStatus;
  List<String> _ssidList = [];

  final TextEditingController passwordController = TextEditingController();
  String ssid = "";

  @override
  void initState() {
    super.initState();
    //connectToMorningDevice();
    _loadWifiList();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> connectToMorningDevice() async {
    try {
      bool isConnected = await WiFiForIoTPlugin.connect(
        "morening",
        password: "12345678",
        joinOnce: true,
        security: NetworkSecurity.WPA,
      );

      if (isConnected) {
        await _loadWifiList();
      }

      setState(() {
        _isConnected = isConnected;
      });
    } catch (e) {
      setState(() {
        _connectionStatus = "Error: $e";
      });
    }
  }

  Future<void> _loadWifiList() async {
    //try {
    final response = await ApiService.deviceGet("network/scan");
    print(response.body);

    //   if (response.statusCode == 200) {
    //     print(response.body);
    //     final data = jsonDecode(response.body) as Map<String, dynamic>;
    //     //final ssidList = data["ssids"] ?? [];

    //     setState(() {
    //       // _ssidList = (ssidList as List)
    //       //     .cast<String>()
    //       //     .where((ssid) => ssid.isNotEmpty)
    //       //     .toList();
    //       _connectionStatus = null;
    //     });
    //   } else {
    //     setState(() {
    //       _connectionStatus =
    //           "Failed to load Wi-Fi list: HTTP ${response.statusCode}";
    //     });
    //   }
    // } catch (e) {
    //   setState(() {
    //     _connectionStatus = "Error loading Wi-Fi list: ${e.toString()}";
    //   });
    // }
  }

  Future<void> sendNetworkCredentials() async {
    // Send selected SSID and password to the device
    try {
      final response = await ApiService.devicePost(
        "network/connect",
        {
          "ssid": ssid,
          "password": passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isConnected = true;
          ssid = "";
        });
      } else {
        setState(() {
          _connectionStatus = "Failed to connect: HTTP ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      child: !_isConnected
          ? _connectMorningDevice()
          : ssid.isEmpty
              ? _selectNetwork()
              : _setNetworkPassword(),
    );
  }

  Widget _connectMorningDevice() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Searching for Nearby Morning Device..."),
        ],
      ),
    );
  }

  Widget _selectNetwork() {
    if (_connectionStatus != null) {
      return Center(
        child: Text(
          _connectionStatus!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (_ssidList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Scanning for available networks..."),
          ],
        ),
      );
    }

    return Column(
      children: [
        const Text(
          "Connect The Device To Your Home Network",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 50),
        Expanded(
          child: ListView(
            children: _ssidList
                .map(
                  (network) => ListTile(
                    leading: const Icon(Icons.wifi),
                    title: Text(network.isEmpty ? 'Unknown' : network),
                    onTap: () => setState(() => ssid = network),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _setNetworkPassword() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Enter Password for the Network",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        AuthTextfield(
          controller: passwordController,
          labelText: "Password",
          obscureText: true,
        ),
        Column(
          children: [
            AuthButton(text: "Connect", onPressed: sendNetworkCredentials),
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
        ),
      ],
    );
  }
}
