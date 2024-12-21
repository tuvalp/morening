import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/settings.dart';
import '../domain/repository/settings_repo.dart';

class SettingsRepoImpl implements SettingsRepo {
  @override
  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = await prefs.getString('settings');

    if (settingsJson == null) {
      return Settings.fromJson({}); // Return default settings if none saved
    }

    return Settings.fromJson(jsonDecode(settingsJson));
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', jsonEncode(settings.toJson()));
  }
}
