abstract class DeviceState {}

class DeviceStatusLoading extends DeviceState {}

class DeviceNotPair extends DeviceState {}

class DeviceConnected extends DeviceState {}

class DeviceDisconnected extends DeviceState {}

class DeviceStatusError extends DeviceState {
  final String message;
  DeviceStatusError(this.message);
}
