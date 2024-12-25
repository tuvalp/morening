import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';

class WifiListScreen extends StatefulWidget {
  @override
  _WifiListScreenState createState() => _WifiListScreenState();
}

class _WifiListScreenState extends State<WifiListScreen> {
  List<WifiNetwork> _wifiNetworks = [];

  @override
  void initState() {
    super.initState();
    _loadWifiList();
  }

  Future<void> _loadWifiList() async {
    // Request location permission if needed
    if (await Permission.location.request().isGranted) {
      try {
        final List<WifiNetwork>? networks =
            await WiFiForIoTPlugin.loadWifiList();
        if (networks != null) {
          setState(() {
            _wifiNetworks = networks;
          });
        }
      } catch (e) {
        print('Error loading Wi-Fi list: $e');
      }
    } else {
      print('Location permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Wi-Fi Networks'),
      ),
      body: _wifiNetworks.isEmpty
          ? Center(child: Text('No Wi-Fi networks found.'))
          : ListView.builder(
              itemCount: _wifiNetworks.length,
              itemBuilder: (context, index) {
                final network = _wifiNetworks[index];
                return ListTile(
                  title: Text(network.ssid ?? 'Unknown'),
                  subtitle: Text('Signal Strength: ${network.level}'),
                );
              },
            ),
    );
  }
}
