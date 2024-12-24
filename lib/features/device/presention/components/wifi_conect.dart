import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiListScreen extends StatefulWidget {
  @override
  _WifiListScreenState createState() => _WifiListScreenState();
}

class _WifiListScreenState extends State<WifiListScreen> {
  List<WifiNetwork> _wifiList = [];

  @override
  void initState() {
    super.initState();
    _loadWifiNetworks();
  }

  Future<void> _loadWifiNetworks() async {
    final wifiList = await WiFiForIoTPlugin.loadWifiList();
    setState(() {
      _wifiList = wifiList;
    });
  }

  void _connectToWifi(String ssid, String password) async {
    final success = await WiFiForIoTPlugin.connect(ssid, password: password);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connected to $ssid")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect to $ssid")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Wi-Fi Networks")),
      body: ListView.builder(
        itemCount: _wifiList.length,
        itemBuilder: (context, index) {
          final wifi = _wifiList[index];
          return ListTile(
            title: Text(wifi.ssid ?? 'Unknown Network'),
            onTap: () {
              // Prompt for password and connect
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Connect to ${wifi.ssid}"),
                  content: TextField(
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onSubmitted: (password) {
                      Navigator.of(context).pop();
                      _connectToWifi(wifi.ssid!, password);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
