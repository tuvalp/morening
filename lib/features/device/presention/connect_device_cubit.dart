import 'package:bloc/bloc.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../../../../services/api_service.dart';

part 'connect_device_state.dart';

class ConnectDeviceCubit extends Cubit<ConnectDeviceState> {
  final ApiService _apiService;

  ConnectDeviceCubit(
    this._apiService,
  ) : super(ConnectDeviceInitial());

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
        emit(ConnectDeviceError("Failed to connect to device."));
      }
    } catch (e) {
      emit(ConnectDeviceError("Error: $e"));
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
      emit(ConnectDeviceError("Error fetching networks: $e"));
    }
  }

  Future<void> sendNetworkCredentials(
      String ssid, String password, String userID) async {
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
        await WiFiForIoTPlugin.disconnect();
        await WiFiForIoTPlugin.forceWifiUsage(false);

        await updateDeviceId(response.data['device_id'], userID);

        emit(ConnectDeviceSuccess());
      } else {
        emit(ConnectDeviceError(
            "Failed to connect: HTTP ${response.statusCode}"));
      }
    } catch (e) {
      emit(ConnectDeviceError(e.toString()));
    }
  }

  Future<bool> updateDeviceId(String deviceId, String userID) async {
    try {
      await _apiService.post(
        "users/pair_user_with_device",
        {"user_id": userID, "device_id": deviceId},
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
