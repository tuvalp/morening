import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/auth/presention/auth_cubit.dart';
import '../domain/models/route.dart';
import '../../alarm/presention/page/alarm_view.dart';

Map<String, MainRoute> mainRoutes = {
  "alarms": MainRoute(
    widget: const AlarmView(),
    icon: Icons.alarm,
  ),
  "settings": MainRoute(
    widget: Container(),
    title: "Plans",
    icon: Icons.assignment,
  ),
  "devices": MainRoute(
    widget: Container(),
    title: "Devices",
    icon: Icons.devices,
  ),
  "profile": MainRoute(
    widget: Center(
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () {
            context.read<AuthCubit>().logout();
          },
          child: const Text("Logout"),
        ),
      ),
    ),
    title: "Profile",
    icon: Icons.account_circle,
  ),
};
