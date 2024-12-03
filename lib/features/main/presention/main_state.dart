import '../domain/models/route.dart';

abstract class MainState {
  const MainState();
}

class MainInitial extends MainState {
  const MainInitial();
}

class MainLoading extends MainState {
  const MainLoading();
}

class MainLoad extends MainState {
  final MainRoute screen;

  const MainLoad(this.screen);
}
