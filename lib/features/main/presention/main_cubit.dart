import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/main/domain/models/route.dart';

import '../../../config/Routes.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainInitial()) {
    checkAuthentication(true);
  }
  // Method to handle alarm ringing
  void onAlarmRing(AlarmSettings alarm) {
    emit(AlarmRingingState(alarm));
  }

  void onWidgetChanged(MainRoute screen) {
    emit(AuthenticatedState(screen));
  }

  // Method to handle authentication
  void checkAuthentication(bool isAuthenticated,
      {String defaultRoute = "alarms"}) {
    if (isAuthenticated) {
      emit(AuthenticatedState(mainRoutes[defaultRoute]!));
    } else {
      emit(UnauthenticatedState());
    }
  }
}
