import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../../../services/api_service.dart';
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
  final _apiService = ApiService();
  bool _isConnected = false;
  String? _connectionStatus;
  List<String> _ssidList = [];
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  String ssid = "";

  @override
  void initState() {
    super.initState();
    connectToMorningDevice();
  }

  @override
  void dispose() {
    passwordController.dispose();
    _connectionStatus = null;
    _isConnected = false;
    super.dispose();
  }

  Future<void> connectToMorningDevice() async {
    try {
      bool isConnected = false;

      // Step 1: Request permission for Wi-Fi scanning
      final permissionStatus = await WiFiScan.instance.canStartScan();

      if (permissionStatus != CanStartScan.yes) {
        setState(() {
          _connectionStatus = "Permission denied for Wi-Fi scanning.";
        });
        return;
      }

      // Step 2: Start scanning for Wi-Fi networks
      try {
        await WiFiScan.instance.startScan();
        await Future.delayed(
            const Duration(seconds: 2)); // Allow time for the scan to complete
      } catch (e) {
        setState(() {
          _connectionStatus = "Error starting Wi-Fi scan: $e";
        });
        return;
      }

      // Step 3: Fetch scanned results
      List<WiFiAccessPoint> accessPoints;
      try {
        accessPoints = await WiFiScan.instance.getScannedResults();
      } catch (e) {
        setState(() {
          _connectionStatus = "Error fetching Wi-Fi scan results: $e";
        });
        return;
      }

      // Step 4: Find the "morening" network
      final morningNetwork = accessPoints.firstWhere(
        (ap) => ap.ssid == "morening",
        orElse: () => WiFiAccessPoint(ssid: ""),
      );

      if (morningNetwork.ssid.isEmpty) {
        setState(() {
          _connectionStatus = "Error: 'morening' network not found.";
        });
        return;
      }

      // Step 5: Connect to the "morening" network
      try {
        isConnected = await WiFiForIoTPlugin.connect(
          morningNetwork.ssid,
          password: "12345678",
        );
      } catch (e) {
        setState(() {
          _connectionStatus = "Error while connecting to 'morening': $e";
        });
        return;
      }

      // Step 6: Update connection status
      if (isConnected) {
        setState(() {
          _isConnected = true;
          _connectionStatus = "Connected to 'morening'.";
        });
        await _loadWifiList();
      } else {
        setState(() {
          _connectionStatus = "Error: Unable to connect to 'morening'.";
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = "Unexpected error: $e";
      });
    }
  }

  Future<void> _loadWifiList() async {
    try {
      final response = await _apiService.deviceGet("network/scan");

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final ssidList = data['ssids'] ?? [];

        setState(() {
          _ssidList = (ssidList as List)
              .cast<String>()
              .toSet()
              .where((ssid) => ssid.isNotEmpty)
              .toList();
          _connectionStatus = null;
        });
      } else {
        setState(() {
          _connectionStatus =
              "Failed to load Wi-Fi list: HTTP ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = "Error loading Wi-Fi list: ${e.toString()}";
        print(e.toString());
      });
    }
  }

  Future<void> sendNetworkCredentials() async {
    try {
      if (ssid.isNotEmpty && passwordController.text.isNotEmpty) {
        if (!_isValidPassword(passwordController.text)) {
          setState(() {
            _connectionStatus = "Password must be at least 8 characters.";
          });
          return;
        }

        final response = await _apiService.devicePost(
          "network/connect",
          {
            "ssid": ssid,
            "password": passwordController.text,
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            ssid = "";
            _connectionStatus = "Connected successfully!";
          });
        } else {
          setState(() {
            _connectionStatus =
                "Failed to connect: HTTP ${response.statusCode}";
          });
        }
      }
    } catch (e) {
      setState(() {
        _connectionStatus = "Error: $e";
      });
    }
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
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
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            _connectionStatus ?? "Searching for Nearby Morning Device...",
            style: const TextStyle(fontSize: 16),
          ),
          if (_connectionStatus != null)
            ElevatedButton(
              onPressed: () => {
                setState(() {
                  _connectionStatus = null;
                }),
                connectToMorningDevice()
              },
              child: const Text("Retry"),
            ),
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
          obscureText: _isPasswordHidden,
          suffixIcon: IconButton(
            icon: Icon(
                _isPasswordHidden ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isPasswordHidden = !_isPasswordHidden;
              });
            },
          ),
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
