import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/services/navigation_service.dart';
import '/utils/snackbar_extension.dart';
import '/services/permission_service.dart';

import 'features/alarm/presention/alarm_cubit.dart';
import 'features/alarm/presention/alarm_state.dart';

import 'features/auth/presention/auth_cubit.dart';
import 'features/auth/presention/auth_state.dart';
import 'features/auth/presention/page/login_screen.dart';

import 'features/main/presention/main_cubit.dart';
import 'features/main/presention/main_state.dart';
import 'features/main/presention/main_view.dart';
import 'services/alarm_service.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final AlarmService _alarmService = AlarmService(context);

  @override
  void initState() {
    super.initState();
    PermissionService.checkPermissions();
    _alarmService.initialize();
  }

  @override
  void dispose() {
    _alarmService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AlarmCubit, AlarmState>(
          listenWhen: (previous, current) =>
              current is AlarmRingingState || current is AlarmError,
          listener: (context, state) {
            if (state is AlarmError) {
              context.showErrorSnackBar(state.message);
              if (context.read<AuthCubit>().state is Authenticated) {
                context.read<MainCubit>().resetMainView();
              }
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              current is Unauthenticated || current is AuthError,
          listener: (context, state) {
            if (state is Unauthenticated || state is AuthError) {
              if (state is AuthError) {
                context.showErrorSnackBar(state.error);
              }
              NavigationService.navigateTo(const LoginScreen(), replace: true);
            }
          },
        ),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        buildWhen: (previous, current) => current is MainLoad,
        builder: (context, state) {
          return state is MainLoad
              ? MainView(screen: state.screen)
              : _buildSplashScreen();
        },
      ),
    );
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MoreNing',
              style: TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
