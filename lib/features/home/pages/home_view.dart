import 'package:flutter/material.dart';
import 'package:morening_2/features/alarm/presention/page/alarm_view.dart';

import '../../../services/navigation_service.dart';
import '../../alarm/presention/page/add_edit_alarm_view.dart';
import '../components/home_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: AlarmView(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          NavigationService.navigateTo(AddEditAlarmView());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
