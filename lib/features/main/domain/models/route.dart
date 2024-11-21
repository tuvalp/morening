import 'package:flutter/material.dart';

class MainRoute {
  final String? title;
  final Widget widget;
  final IconData icon;
  MainRoute({required this.widget, this.title, required this.icon});
}
