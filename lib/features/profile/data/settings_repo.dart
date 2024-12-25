import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/settings.dart';
import '../domain/repository/settings_repo.dart';

class SettingsRepoImpl implements SettingsRepo {
  Settings? _cachedSettings;

  @override
  Future<Settings> getSettings() async {
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('settings');
    _cachedSettings = settingsJson == null
        ? Settings.fromJson({})
        : Settings.fromJson(jsonDecode(settingsJson));

    return _cachedSettings!;
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', jsonEncode(settings.toJson()));
    _cachedSettings = settings; // Update cache
  }
}
