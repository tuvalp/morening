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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Alarms',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];
                    return Column(children: [
                      const SizedBox(height: 8),
                      AlarmTile(alarm: alarm),
                      const SizedBox(height: 8),
                      Divider(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
