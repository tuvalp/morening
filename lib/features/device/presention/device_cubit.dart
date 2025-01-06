import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final String userID;
  DeviceCubit(this.userID) : super(DeviceState());

  Future<bool> updateDeviceId(String deviceId) async {
    emit(DeviceState());
    final apiService = ApiService();
    try {
      await apiService.post(
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

class DeviceState {}
