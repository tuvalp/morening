import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:morening_2/services/api_service.dart';
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
  bool _isConnected = false;
  String? _connectionStatus;
  List<String> _ssidList = [];

  final TextEditingController passwordController = TextEditingController();
  String ssid = "";

  selectSsid(String selectedSsid) {
    setState(() {
      ssid = selectedSsid;
    });
  }

  Future<void> connectToMorningDevice() async {
    try {
      bool isConnected = await WiFiForIoTPlugin.connect(
        "morening",
        password: "12345678",
        security: NetworkSecurity.WPA,
        joinOnce: true,
      );

      _loadWifiList();

      setState(() {
        _isConnected = isConnected;
        _connectionStatus =
            isConnected ? "Connected to $ssid" : "Failed to connect to $ssid";
      });
    } catch (e) {
      setState(() {
        _connectionStatus = "Error: $e";
      });
    }
  }

  Future<void> _loadWifiList() async {
    try {
      final response = await ApiService.deivceGet("network/scan");

      if (response.statusCode == 200) {
        final List<dynamic> ssidList = jsonDecode(response.body)["ssids"];

        setState(() {
          _ssidList =
              ssidList.cast<String>().where((ssid) => ssid.isNotEmpty).toList();
        });

        print('Loaded Wi-Fi list: $_ssidList');
      } else {
        print('Failed to load Wi-Fi list: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading Wi-Fi list: $e');
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
      child: !_isConnected
          ? _connectMoreningDevice()
          : ssid.isEmpty
              ? _selectNetwork()
              : _setNetworkPassword(),
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
              for (ssid in _ssidList)
                ListTile(
                  leading: Icon(Icons.wifi),
                  title: Text(ssid.isEmpty ? 'Unknown' : ssid),
                  onTap: () {
                    selectSsid(ssid);
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
