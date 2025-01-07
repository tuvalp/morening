import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presention/auth_cubit.dart';
import '../../../auth/presention/auth_state.dart';
import '../../../auth/presention/components/auth_button.dart';
import '../../../auth/presention/components/auth_textfield.dart';
import '/features/device/presention/connect_device_cubit.dart';
import '/services/api_service.dart';

class ConnectDevice extends StatelessWidget {
  const ConnectDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
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
  String selectedSsid = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: BlocProvider<ConnectDeviceCubit>(
        create: (_) => ConnectDeviceCubit(
          ApiService(),
        ),
        child: BlocBuilder<ConnectDeviceCubit, ConnectDeviceState>(
          builder: (context, state) {
            if (state is ConnectDeviceInitial) {
              context.read<ConnectDeviceCubit>().connectToDeviceWiFi();
              return _buildConnectingUI("Connecting to Morening Device...");
            } else if (state is ConnectDeviceLoading) {
              return _buildConnectingUI("Connecting to Morening Device...");
            } else if (state is ConnectDeviceConnected) {
              return _buildConnectingUI("Connected. Scanning for networks...");
            } else if (state is ConnectDeviceFetchingNetworks) {
              return _buildConnectingUI("Scanning for networks...");
            } else if (state is ConnectDeviceNetworksFetched) {
              return _buildNetworkSelectionUI(context, state.ssidList);
            } else if (state is ConnectDevicePairing) {
              return _buildConnectingUI("Connecting to network...");
            } else if (state is ConnectDeviceSuccess) {
              return _buildConnectionSuccessUI(context);
            } else if (state is ConnectDeviceError) {
              return _buildErrorUI(context, state.message);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildConnectingUI(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkSelectionUI(BuildContext context, List<String> ssidList) {
    final passwordController = TextEditingController();

    return selectedSsid == ""
        ? Column(children: [
            const Text(
              "Connect your device to your home network",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ssidList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: const Icon(Icons.wifi),
                      title: Text(ssidList[index]),
                      onTap: () => setState(() {
                            selectedSsid = ssidList[index];
                          }));
                },
              ),
            )
          ])
        : Center(
            child: Column(
              children: [
                Text(
                  selectedSsid,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 42),
                AuthTextfield(
                  controller: passwordController,
                  obscureText: true,
                  labelText: 'Password',
                ),
                const SizedBox(height: 16),
                AuthButton(
                  onPressed: () {
                    final auth =
                        context.read<AuthCubit>().state as Authenticated;
                    final userID = auth.user.id;
                    context.read<ConnectDeviceCubit>().sendNetworkCredentials(
                        selectedSsid, passwordController.text, userID);
                  },
                  text: "Connect",
                ),
                SizedBox(height: 8),
                TextButton(
                    onPressed: () => setState(() {
                          selectedSsid = "";
                        }),
                    child: Text("Back"))
              ],
            ),
          );
  }

  Widget _buildConnectionSuccessUI(BuildContext context) {
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

  Widget _buildErrorUI(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () =>
                context.read<ConnectDeviceCubit>().connectToDeviceWiFi(),
            child: const Text(
              "Retry",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
