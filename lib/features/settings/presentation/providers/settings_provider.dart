import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../search/presentation/providers/search_provider.dart'
    show sharedPreferencesProvider;
import '../../data/datasources/settings_local_data_source.dart';

final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>(
  (ref) => SettingsLocalDataSourceImpl(ref.watch(sharedPreferencesProvider)),
);

/// Holds the app's current [ThemeMode], persisting every change so it
/// survives restarts.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  late final SettingsLocalDataSource _dataSource;

  @override
  ThemeMode build() {
    _dataSource = ref.watch(settingsLocalDataSourceProvider);
    return _dataSource.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _dataSource.setThemeMode(mode);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
