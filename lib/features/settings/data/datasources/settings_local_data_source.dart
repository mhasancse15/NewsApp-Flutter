import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

/// Persists the user's chosen [ThemeMode] (System / Light / Dark).
abstract class SettingsLocalDataSource {
  ThemeMode getThemeMode();
  Future<void> setThemeMode(ThemeMode mode);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  ThemeMode getThemeMode() {
    final String? raw = _prefs.getString(StorageKeys.themeMode);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(StorageKeys.themeMode, mode.name);
  }
}
