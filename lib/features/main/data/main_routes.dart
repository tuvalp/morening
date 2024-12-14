import 'package:flutter/material.dart';
import '../../profile/presention/pages/profile_screen.dart';
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
    widget: ProfileScreen(),
    title: "Profile",
    icon: Icons.account_circle,
  ),
};
