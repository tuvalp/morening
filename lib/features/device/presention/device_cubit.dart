import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final String userID;
  DeviceCubit(this.userID) : super(DeviceState());

  void updateDeviceId(String deviceId) async {
    emit(DeviceState());
    final apiService = ApiService();
    try {
      await apiService
          .post("pair_device", {"name": userID, "device_id": deviceId});
    } catch (e) {
      print(e);
    }
  }
}

class DeviceState {}
