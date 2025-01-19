import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakeyAi/features/device/presention/device_cubit.dart';

import '/services/navigation_service.dart';
import '/utils/snackbar_extension.dart';
import '/services/permission_service.dart';

import 'features/auth/presention/auth_cubit.dart';
import 'features/auth/presention/auth_state.dart';
import 'features/auth/presention/page/login_screen.dart';
import 'features/home/pages/home_view.dart';
import 'features/questionnaire/presention/pages/set_up_questionaire.dart';
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
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is AuthError) {
          context.showErrorSnackBar(state.error);
        }
        if (state is Unauthenticated) {
          NavigationService.navigateTo(const LoginScreen(), replace: true);
        }
        if (state is WakeupUnset) {
          NavigationService.navigateTo(
            SetUpQuestionaire(userID: state.user.id),
            replace: true,
          );
        }

        if (state is Authenticated) {
          context.read<DeviceCubit>().initialize();
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoading) {
            return _buildSplashScreen();
          }
          if (authState is Authenticated) {
            return const HomeView();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }

  Widget _buildSplashScreen() {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/logo/logo.png'),
          height: 100,
        ),
      ),
    );
  }
}
