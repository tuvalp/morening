import 'dart:io';

import 'package:bloc/bloc.dart';
import '/features/auth/domain/models/app_user.dart';
import '/features/device/presention/device_cubit.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../../../../services/api_service.dart';

part 'connect_device_state.dart';

class ConnectDeviceCubit extends Cubit<ConnectDeviceState> {
  final ApiService _apiService;
  final DeviceCubit _deviceCubit;

  ConnectDeviceCubit(this._apiService, this._deviceCubit)
      : super(ConnectDeviceInitial());

  Future<void> connectToDeviceWiFi() async {
    emit(ConnectDeviceLoading());
    try {
      bool isConnected = await WiFiForIoTPlugin.connect(
        "morening",
        password: "12345678",
        security: NetworkSecurity.WPA,
      );

      if (isConnected) {
        await WiFiForIoTPlugin.forceWifiUsage(true);
        emit(ConnectDeviceConnected());
        await fetchNetworkList();
      } else {
        emit(ConnectDeviceError("Failed to connect to device Wi-Fi."));
      }
    } catch (e) {
      emit(ConnectDeviceError("Error while connecting to Wi-Fi: $e"));
    }
  }

  Future<void> fetchNetworkList() async {
    emit(ConnectDeviceFetchingNetworks());
    try {
      final response = await _apiService.deviceGet("network/scan");
      if (response.statusCode == 200) {
        final ssidList = List<String>.from(response.data['ssids'] ?? []);
        emit(ConnectDeviceNetworksFetched(ssidList));
      } else {
        emit(ConnectDeviceError(
            "Failed to fetch networks: HTTP ${response.statusCode}"));
      }
    } catch (e) {
      emit(ConnectDeviceError("Error fetching network list: $e"));
    }
  }

  Future<void> sendNetworkCredentials(
      String ssid, String password, AppUser user) async {
    if (ssid.isEmpty || password.isEmpty) {
      emit(ConnectDeviceError('Please enter both SSID and password.'));
      return;
    }
    if (password.length < 8) {
      emit(ConnectDeviceError('Password must be at least 8 characters.'));
      return;
    }

    emit(ConnectDevicePairing());

    try {
      final response = await _apiService.devicePost(
        "network/connect",
        {
          "ssid": ssid,
          "password": password,
        },
      );

      if (response.statusCode == 202) {
        // Attempt to disconnect from the current Wi-Fi
        try {
          await WiFiForIoTPlugin.disconnect();
        } catch (e) {
          print("Failed to disconnect Wi-Fi: $e");
        }

        if (Platform.isAndroid) {
          // Handle Android-specific Wi-Fi usage
          await WiFiForIoTPlugin.forceWifiUsage(false);
          await _deviceCubit.pairDevice(response.data['device_id'], user.id);
        } else {
          // Retry mechanism for non-Android platforms
          const maxRetries = 5;
          int retryCount = 0;
          bool paired = false;

          while (retryCount < maxRetries && !paired) {
            await Future.delayed(const Duration(seconds: 2));
            paired = await _deviceCubit.pairDevice(
                response.data['device_id'], user.id);
            retryCount++;
          }

          if (!paired) {
            emit(ConnectDeviceError(
                "Failed to pair device after $maxRetries attempts."));
            return;
          }
        }

        emit(ConnectDeviceSuccess());
      } else {
        emit(ConnectDeviceError(
            "Failed to connect: HTTP ${response.statusCode}"));
      }
    } catch (e) {
      emit(ConnectDeviceError("Error during pairing: $e"));
    } finally {
      // Ensure Wi-Fi usage is reset
      try {
        await WiFiForIoTPlugin.forceWifiUsage(false);
      } catch (e) {
        print("Error resetting Wi-Fi usage: $e");
      }
    }
  }
}
