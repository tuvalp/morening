import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/alarm/presention/page/alarm_view.dart';

import '../../../services/navigation_service.dart';
import '../../alarm/presention/page/add_edit_alarm_view.dart';
import '../../auth/presention/auth_cubit.dart';
import '../../auth/presention/auth_state.dart';
import '../components/home_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    )),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return Text(
                        state.user.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    } else {
                      return Text(
                        "Unauthenticated",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          AlarmView(),
        ],
      ),
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
