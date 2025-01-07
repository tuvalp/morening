import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/device/presention/device_cubit.dart';

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
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            return BlocProvider<DeviceCubit>(
              create: (_) => DeviceCubit(authState.user.id),
              child: const HomeView(),
            );
          } else {
            // Show a loading screen or placeholder while waiting for authentication
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
