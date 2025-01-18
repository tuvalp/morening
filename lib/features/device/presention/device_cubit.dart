import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/presention/auth_cubit.dart';
import '/features/auth/presention/auth_state.dart';
import '../data/device_api_repo.dart';
import 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final AuthCubit authCubit;
  Timer? _timer;

  DeviceCubit(this.authCubit) : super(DeviceStatusLoading()) {
    checkDeviceStatus();
  }

  // Start periodic device status checks

  Future<void> checkDeviceStatus() async {
    final state = authCubit.state;
    if (state is! Authenticated) {
      emit(DeviceStatusError("User not authenticated"));
      return;
    }

    final user = state.user;
    if (user.deviceId == null || user.deviceId!.isEmpty) {
      emit(DeviceNotPair());
    } else {
      try {
        final status = await DeviceApiRepo().checkDeviceStatus(user.id);
        if (status == "connected") {
          emit(DeviceConnected());
        } else {
          emit(DeviceDisconnected());
        }
      } catch (e) {
        print("Error: $e");
        emit(DeviceStatusError("Error checking device status"));
      }

      _timer = Timer.periodic(
          const Duration(seconds: 20), (_) => checkDeviceStatus());
    }
  }

  Future<void> pairDevice(String deviceId, String userID) async {
    final state = authCubit.state;
    if (state is! Authenticated) {
      emit(DeviceStatusError("User not authenticated"));
      return;
    }

    try {
      await DeviceApiRepo().pairDevice(deviceId, userID);
      await authCubit.getCurrentUser();
      emit(DeviceConnected());
    } catch (e) {
      print("Error: $e");
      emit(DeviceStatusError("Error pairing device"));
    }
  }

  Future<void> unpairDevice() async {
    final state = authCubit.state;
    if (state is! Authenticated) {
      emit(DeviceStatusError("User not authenticated"));
      return;
    }

    final user = state.user;
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
