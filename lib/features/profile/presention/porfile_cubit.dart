import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/models/settings.dart';
import '../domain/repository/settings_repo.dart';

class ProfileCubit extends Cubit<Settings> {
  final SettingsRepo settingsRepo;

  ProfileCubit(this.settingsRepo) : super(Settings()) {
    getSettings(); // Automatically fetch settings on cubit initialization
  }

  Future<void> getSettings() async {
    final settings = await settingsRepo.getSettings();
    emit(settings);
  }

  Future<void> saveSettings(Settings settings) async {
    await settingsRepo.saveSettings(settings);
    emit(settings);
  }
}
