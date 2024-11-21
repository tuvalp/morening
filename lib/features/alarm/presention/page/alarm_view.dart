import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/alarm.dart';
import '../alarm_cubit.dart';
import '../components/alarm_tlie.dart';

class AlarmView extends StatelessWidget {
  const AlarmView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmCubit, List<Alarm>>(
      builder: (context, alarms) {
        return ListView.builder(
          itemCount: alarms.length,
          itemBuilder: (context, index) {
            final alarm = alarms[index];
            return Column(children: [
              AlarmTile(alarm: alarm),
              Divider(color: Theme.of(context).colorScheme.tertiary),
            ]);
          },
        );
      },
    );
  }
}
