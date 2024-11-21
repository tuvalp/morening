import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/Routes.dart';
import '../main_cubit.dart';
import '../main_state.dart';

class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    Color isActive(String routeName) {
      final state = context.read<MainCubit>().state;

      if (state is AuthenticatedState &&
          state.screen == mainRoutes[routeName]) {
        return Theme.of(context).colorScheme.inversePrimary;
      }
      return Theme.of(context).colorScheme.primary;
    }

    return SafeArea(
      child: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: mainRoutes.keys.map((routeName) {
            final route = mainRoutes[routeName]!;

            return GestureDetector(
              child: Icon(
                route.icon,
                color: isActive(routeName),
              ),
              onTap: () {
                context.read<MainCubit>().onWidgetChanged(route);
                setState(() {});
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
