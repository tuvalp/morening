import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/questionnaire/presention/pages/set_up_questionaire.dart';

import '/services/navigation_service.dart';
import '/utils/snackbar_extension.dart';
import '/services/permission_service.dart';

import 'features/auth/presention/auth_cubit.dart';
import 'features/auth/presention/auth_state.dart';
import 'features/auth/presention/page/login_screen.dart';
import 'features/home/pages/home_view.dart';
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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated ||
            state is Unconfirmed ||
            state is AuthError) {
          if (state is AuthError) {
            context.showErrorSnackBar(state.error);
          }
          if (state is Unauthenticated) {
            NavigationService.navigateTo(const LoginScreen(), replace: true);
          }
          if (state is Unconfirmed) {}
        }
      },
      child: const HomeView(),
    );
  }
}
