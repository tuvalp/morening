import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/services/alarm_service.dart';
import '/services/navigation_service.dart';
import '/utils/snackbar_extension.dart';
import '/services/permission_service.dart';

import 'features/alarm/presention/alarm_cubit.dart';
import 'features/alarm/presention/alarm_state.dart';
import 'features/alarm/presention/page/alarm_ring.dart';

import 'features/auth/presention/auth_cubit.dart';
import 'features/auth/presention/auth_state.dart';
import 'features/auth/presention/page/login_screen.dart';

import 'features/main/presention/main_cubit.dart';
import 'features/main/presention/main_state.dart';
import 'features/main/presention/main_view.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final AlarmService _alarmService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    PermissionService.checkPermissions();
    _initializeAlarmService();
  }

  Future<void> _initializeAlarmService() async {
    if (!_isInitialized) {
      _alarmService = AlarmService(context);
      await _alarmService.initialize();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _alarmService.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<AlarmCubit, AlarmState>(
          listenWhen: (previous, current) =>
              current is AlarmRingingState || current is AlarmError,
          listener: (context, state) {
            if (state is AlarmRingingState) {
              NavigationService.navigateTo(AlarmRingView(alarm: state.alarm));
            } else if (state is AlarmError) {
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
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
