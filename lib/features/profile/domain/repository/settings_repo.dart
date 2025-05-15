import '../models/settings.dart';

abstract class SettingsRepo {
  Future<Settings> getSettings();
  Future<void> saveSettings(Settings settings);
}
