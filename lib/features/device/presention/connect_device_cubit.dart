import 'package:bloc/bloc.dart';
import 'package:morening_2/features/auth/domain/models/app_user.dart';
import 'package:morening_2/features/device/presention/device_cubit.dart';
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
        await WiFiForIoTPlugin.disconnect();
        //await WiFiForIoTPlugin.forceWifiUsage(false);

        await _deviceCubit.pairDevice(response.data['device_id'], user.id);

        emit(ConnectDeviceSuccess());
      } else {
        emit(ConnectDeviceError(
            "Failed to connect: HTTP ${response.statusCode}"));
      }
    } catch (e) {
      emit(ConnectDeviceError(e.toString()));
    }
  }
}
