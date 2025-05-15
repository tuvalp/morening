import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/profile/presention/porfile_cubit.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

class AppTheme {
  static ThemeData getTheme(BuildContext context) {
    final settings = context.watch<ProfileCubit>().state;
    return settings.darkMode ? darkTheme() : lightTheme();
  }
}
