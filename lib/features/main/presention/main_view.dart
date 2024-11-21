import 'package:flutter/material.dart';
import 'package:morening_2/features/main/domain/models/route.dart';

import 'components/main_app_bar.dart';
import 'components/main_bottom_bar.dart';

class MainView extends StatelessWidget {
  final MainRoute screen;
  const MainView({required this.screen, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: screen.title,
      ),
      body: screen.widget,
      bottomNavigationBar: const MainBottomNavBar(),
    );
  }
}
