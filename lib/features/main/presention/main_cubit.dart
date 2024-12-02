import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/main/domain/models/route.dart';

import '../../../config/Routes.dart';
import '../../auth/presention/auth_cubit.dart';
import '../../auth/presention/auth_state.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final AuthCubit authCubit;

  MainCubit(this.authCubit) : super(const MainInitial()) {
    checkAuthentication();
  }

  // Method to handle alarm ringing
  void onAlarmRing(AlarmSettings alarm) {
    emit(AlarmRingingState(alarm));
  }

  void onWidgetChanged(MainRoute screen) {
    final currentState = authCubit.state;
    if (currentState is AuthUserLoaded) {
      emit(AuthenticatedState(screen, currentState.user));
    }
  }

  // Method to handle authentication
  void checkAuthentication() async {
    emit(MainLoading());
    try {
      final user = await authCubit.getCurrentUser();
      if (user.isNotEmpty) {
        String defaultRoute = "alarms";
        emit(AuthenticatedState(mainRoutes[defaultRoute]!, user));
      } else {
        emit(UnauthenticatedState());
      }
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }
}
