import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/auth/domain/models/app_user.dart';
import '../data/device_api_repo.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final AppUser user;
  Timer? _timer;

  DeviceCubit(this.user) : super(DeviceStatusLoading()) {
    _startPeriodicCheck();
  }

  // Start periodic device status checks
  void _startPeriodicCheck() {
    checkDeviceStatus(); // Run an immediate check
    _timer =
        Timer.periodic(const Duration(minutes: 1), (_) => checkDeviceStatus());
  }

  Future<void> checkDeviceStatus() async {
    emit(DeviceStatusLoading());
    try {
      if (user.deviceId == null || user.deviceId!.isEmpty) {
        print("No paired device");
        emit(DeviceNotPair());
        return;
      }

      final status = await DeviceApiRepo().checkDeviceStatus(user.id);

      emit(DeviceStatus(status));
    } catch (e) {
      print("Error: $e");
      emit(DeviceStatusError("Error checking device status"));
    }
  }

  Future<void> unpairDevice() async {
    try {
      await DeviceApiRepo().unpairDevice(user.id);
      emit(DeviceNotPair());
    } catch (e) {
      print("Error: $e");
      emit(DeviceStatusError("Error unpairing device"));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Cancel the timer when the Cubit is closed
    return super.close();
  }
}

// States for the DeviceCubit
abstract class DeviceState {}

class DeviceStatusLoading extends DeviceState {}

class DeviceNotPair extends DeviceState {}

class DeviceStatus extends DeviceState {
  final String status;
  DeviceStatus(this.status);
}

class DeviceStatusError extends DeviceState {
  final String message;
  DeviceStatusError(this.message);
}
