import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service.dart';

class DeviceCubit extends Cubit<DeviceState> {
  DeviceCubit(this.userId) : super(DeviceState());
  final String userId;

  void updateDeviceId(String deviceId) {
    emit(DeviceState());
    ApiService().post("/pair_device", {"name": userId, "device_id": deviceId});
  }
}

class DeviceState {}
