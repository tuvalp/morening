part of 'connect_device_cubit.dart';

abstract class ConnectDeviceState {}

class ConnectDeviceInitial extends ConnectDeviceState {}

class ConnectDeviceLoading extends ConnectDeviceState {}

class ConnectDeviceConnected extends ConnectDeviceState {}

class ConnectDeviceFetchingNetworks extends ConnectDeviceState {}

class ConnectDeviceNetworksFetched extends ConnectDeviceState {
  final List<String> ssidList;
  ConnectDeviceNetworksFetched(this.ssidList);
}

class ConnectDevicePairing extends ConnectDeviceState {}

class ConnectDeviceSuccess extends ConnectDeviceState {}

class ConnectDeviceError extends ConnectDeviceState {
  final String message;
  ConnectDeviceError(this.message);
}
