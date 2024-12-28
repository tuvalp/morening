import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../../../services/api_service.dart';

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
    connectToDeviceWiFi();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  /// Connect to the device's Wi-Fi
  Future<void> connectToDeviceWiFi() async {
    bool isConnected = false;
    WiFiAccessPoint? morningNetwork;

    try {
      setState(() => _connectionStatus = "Searching for Morening' Device...");
      final permissionStatus = await WiFiScan.instance.canStartScan();
      if (permissionStatus != CanStartScan.yes) {
        setState(() => _connectionStatus = "Wi-Fi scanning permission denied.");
        return;
      }

      await WiFiScan.instance.startScan();
      await Future.delayed(const Duration(seconds: 2));
      final accessPoints = await WiFiScan.instance.getScannedResults();

      try {
        morningNetwork = accessPoints.firstWhere(
          (ap) => ap.ssid == "morening",
        );
      } catch (e) {
        morningNetwork = null;
      }

      if (morningNetwork == null) {
        setState(() => _connectionStatus = "'Morening Device not found.");
        return;
      }

      isConnected = await WiFiForIoTPlugin.connect(
        morningNetwork.ssid,
        password: "12345678",
        security: NetworkSecurity.WEP,
      );

      if (isConnected) {
        setState(() => _isConnected = true);
        await bindToDeviceWiFi();
        await fetchNetworkList();
      } else {
        setState(() => _connectionStatus = "Failed to connect to device.");
      }
    } catch (e) {
      setState(() => _connectionStatus = "Error: $e");
    }
  }

  Future<void> bindToDeviceWiFi() async {
    try {
      await WiFiForIoTPlugin.forceWifiUsage(true);
      print('Successfully bound to device Wi-Fi.');
    } catch (e) {
      print('Error binding to device Wi-Fi: $e');
    }
  }

  Future<void> fetchNetworkList() async {
    try {
      final response = await _apiService.deviceGet("network/scan");
      if (response.statusCode == 200) {
        final ssidList = List<String>.from(response.data['ssids'] ?? []);
        setState(() => _ssidList = ssidList);
      } else {
        setState(() => _connectionStatus =
            "Failed to fetch networks: HTTP ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _connectionStatus = "Error fetching networks: $e");
    }
  }

  Future<void> sendNetworkCredentials() async {
    if (ssid.isEmpty || passwordController.text.isEmpty) {
      setState(() => _connectionStatus = "SSID or password is empty.");
      return;
    }
    if (passwordController.text.length < 8) {
      setState(
          () => _connectionStatus = "Password must be at least 8 characters.");
      return;
    }

    try {
      final response = await _apiService.devicePost(
        "network/connect",
        {"ssid": ssid, "password": passwordController.text},
      );

      if (response.statusCode == 200) {
        setState(() => _connectionStatus = "Connected to $ssid!");
      } else {
        setState(() => _connectionStatus =
            "Failed to connect: HTTP ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _connectionStatus = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      child: !_isConnected
          ? _buildConnectingUI()
          : ssid.isEmpty
              ? _buildNetworkSelectionUI()
              : _buildPasswordInputUI(),
    );
  }

  Widget _buildConnectingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            _connectionStatus ?? "Connecting to Morening Device...",
            style: const TextStyle(fontSize: 16),
          ),
          _connectionStatus != null
              ? ElevatedButton(
                  onPressed: connectToDeviceWiFi,
                  child: const Text("Retry"),
                )
              : CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildNetworkSelectionUI() {
    return _ssidList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  _connectionStatus ?? "Scanning for networks...",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        : ListView(
            children: _ssidList.map((network) {
              return ListTile(
                leading: const Icon(Icons.wifi),
                title: Text(network),
                onTap: () => setState(() => ssid = network),
              );
            }).toList(),
          );
  }

  Widget _buildPasswordInputUI() {
    return Column(
      children: [
        TextField(
          controller: passwordController,
          obscureText: _isPasswordHidden,
          decoration: InputDecoration(
            labelText: "Password",
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => _isPasswordHidden = !_isPasswordHidden),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: sendNetworkCredentials,
          child: const Text("Connect"),
        ),
        TextButton(
          onPressed: () => setState(() => ssid = ""),
          child: const Text("Select Another Network"),
        ),
      ],
    );
  }
}
