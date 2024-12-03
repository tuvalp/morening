import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/main/domain/models/route.dart';

import '../data/main_routes.dart';
import '../../auth/presention/auth_cubit.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final AuthCubit authCubit;

  MainCubit(this.authCubit) : super(const MainInitial()) {
    mainHome();
  }

  void mainHome() {
    onWidgetChanged(mainRoutes["alarms"]!);
  }

  // Method to handle alarm ringing

  void onWidgetChanged(MainRoute screen) {
    emit(MainLoad(screen));
  }

  // Method to handle authentication
  // void checkAuthentication() async {
  //   emit(MainLoading());
  //   try {
  //     final user = await authCubit.getCurrentUser();
  //     if (user.isNotEmpty) {
  //       print("user: $user");
  //       String defaultRoute = "alarms";
  //       emit(AuthenticatedState(mainRoutes[defaultRoute]!, user));
  //     } else {
  //       emit(UnauthenticatedState());
  //     }
  //   } catch (e) {
  //     emit(UnauthenticatedState());
  //   }
  // }
}
