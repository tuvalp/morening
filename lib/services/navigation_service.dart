import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> navigateTo(Widget screen, {bool replace = false}) async {
    final navigatorState = navigatorKey.currentState!;
    final route = MaterialPageRoute(builder: (_) => screen);

    if (replace) {
      if (navigatorState.canPop()) {
        await navigatorState.pushReplacement(route);
      } else {
        await navigatorState.push(route);
      }
    } else {
      await navigatorState.push(route);
    }
  }

  static Future<void> navigateToNamed(String routeName,
      {bool replace = false, Object? arguments}) async {
    final navigatorState = navigatorKey.currentState!;

    if (replace) {
      if (navigatorState.canPop()) {
        await navigatorState.pushReplacementNamed(routeName,
            arguments: arguments);
      } else {
        await navigatorState.pushNamed(routeName, arguments: arguments);
      }
    } else {
      await navigatorState.pushNamed(routeName, arguments: arguments);
    }
  }

  static void pop() {
    final navigatorState = navigatorKey.currentState!;
    if (navigatorState.canPop()) {
      navigatorState.pop();
    }
  }
}
