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
    initialize();
  }

  Future<void> initialize() async {
    await _checkAndStartPeriodicStatusCheck();
  }

  Future<void> _checkAndStartPeriodicStatusCheck() async {
    if (_timer != null) return; // Prevent multiple timers

    await _checkDeviceStatus();

    if (authCubit.state is! Authenticated) return;

    // Start periodic device status checks
    _timer = Timer.periodic(
      const Duration(seconds: 20),
      (_) => _checkDeviceStatus(),
    );

    // Perform an initial check
  }

  Future<void> _checkDeviceStatus() async {
    if (authCubit.state is! Authenticated) return;

    final user = (authCubit.state as Authenticated).user;
    if (user.deviceId == null || user.deviceId!.isEmpty) {
      emit(DeviceNotPair());
      return;
    }

    try {
      final status = await DeviceApiRepo().checkDeviceStatus(user.id);
      emit(status == "connected" ? DeviceConnected() : DeviceDisconnected());
    } catch (e) {
      emit(DeviceStatusError("Error checking device status: $e"));
    }
  }

  Future<void> pairDevice(String deviceId, String userID) async {
    if (authCubit.state is! Authenticated) return;

    try {
      await DeviceApiRepo().pairDevice(deviceId, userID);
      await authCubit.getCurrentUser();
      await _checkDeviceStatus();
      await _checkAndStartPeriodicStatusCheck();
    } catch (e) {
      emit(DeviceStatusError("Error pairing device: $e"));
    }
  }

  Future<void> unpairDevice() async {
    if (authCubit.state is! Authenticated) return;

    final user = (authCubit.state as Authenticated).user;
    try {
      await DeviceApiRepo().unpairDevice(user.id);
      emit(DeviceNotPair());
    } catch (e) {
      emit(DeviceStatusError("Error unpairing device: $e"));
    }
  }

  void _stopPeriodicStatusCheck() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _stopPeriodicStatusCheck();
    return super.close();
  }
}
