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

  void loadMainView() {
    emit(MainLoad(mainRoutes["alarms"]!));
  }

  void resetMainView() {
    emit(MainInitial());
  }

  void mainHome() {
    onWidgetChanged(mainRoutes["alarms"]!);
  }

  void onWidgetChanged(MainRoute screen) {
    emit(MainLoad(screen));
  }
}
