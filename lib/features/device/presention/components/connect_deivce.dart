import 'package:flutter/material.dart';
import 'package:morening_2/features/auth/presention/components/auth_button.dart';
import 'package:morening_2/features/auth/presention/components/auth_textfield.dart';
import 'package:morening_2/utils/snackbar_extension.dart';
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
  String? _connectionError;
  bool _connectionSuccess = false;
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

  Future<void> connectToDeviceWiFi() async {
    bool isConnected = false;
    WiFiAccessPoint? morningNetwork;

    setState(() {
      _connectionError = null;
      _connectionSuccess = false;
    });

    try {
      final permissionStatus = await WiFiScan.instance.canStartScan();
      if (permissionStatus != CanStartScan.yes) {
        setState(() => _connectionError = "Wi-Fi scanning permission denied.");
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
        setState(() => _connectionError = "'Morening Device not found.");
        return;
      }

      isConnected = await WiFiForIoTPlugin.connect(
        morningNetwork.ssid,
        password: "12345678",
        security: NetworkSecurity.WPA,
      );

      if (isConnected) {
        setState(() => _isConnected = true);
        await bindToDeviceWiFi();
        await fetchNetworkList();
      } else {
        setState(() => _connectionError = "Failed to connect to device.");
      }
    } catch (e) {
      setState(() => _connectionError = "Error: $e");
    }
  }

  Future<void> bindToDeviceWiFi() async {
    try {
      await WiFiForIoTPlugin.forceWifiUsage(true);
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
        setState(() => _connectionError =
            "Failed to fetch networks: HTTP ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _connectionError = "Error fetching networks: $e");
    }
  }

  Future<void> sendNetworkCredentials() async {
    if (ssid.isEmpty || passwordController.text.isEmpty) {
      context.showErrorSnackBar('Please enter both SSID and password.');
      return;
    }
    if (passwordController.text.length < 8) {
      context.showErrorSnackBar('Password must be at least 8 characters.');

      return;
    }

    try {
      final response = await _apiService.devicePost(
        "network/connect",
        {"ssid": ssid, "password": passwordController.text},
      );

      if (response.statusCode == 200) {
        setState(() => _connectionSuccess = true);
        print(response.data);
      } else {
        context.showErrorSnackBar(
            "Failed to connect: HTTP ${response.statusCode}");
      }
    } catch (e) {
      context.showErrorSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(24),
        child: _connectionSuccess
            ? _buildConnectionSuccessUI()
            : !_isConnected
                ? _buildConnectingUI()
                : ssid.isEmpty
                    ? _buildNetworkSelectionUI()
                    : _buildPasswordInputUI(),
      ),
    );
  }

  Widget _buildConnectingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_connectionError == null) const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            _connectionError ?? "Connecting to Morening Device...",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          if (_connectionError != null)
            TextButton(
              onPressed: connectToDeviceWiFi,
              child: const Text("Retry"),
            )
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
                  _connectionError ?? "Scanning for networks...",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Text(
                "Connnect your device to your home networks",
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: ListView(
                  children: _ssidList.map((network) {
                    return ListTile(
                      leading: const Icon(Icons.wifi),
                      title: Text(network),
                      onTap: () => setState(() => ssid = network),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
  }

  Widget _buildPasswordInputUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AuthTextfield(
          controller: passwordController,
          obscureText: _isPasswordHidden,
          labelText: 'Password',
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () =>
                setState(() => _isPasswordHidden = !_isPasswordHidden),
          ),
        ),
        const SizedBox(height: 16),
        AuthButton(
          onPressed: sendNetworkCredentials,
          text: "Connect",
        ),
        SizedBox(height: 16),
        TextButton(
          onPressed: () => setState(() => ssid = ""),
          child: const Text("Select Another Network"),
        ),
      ],
    );
  }

  Widget _buildConnectionSuccessUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 80,
          ),
          const SizedBox(height: 16),
          const Text(
            "Connection Successful",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
