import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

/// Persists the user's recent search queries so they survive app restarts.
abstract class RecentSearchesDataSource {
  Future<List<String>> getRecentSearches();
  Future<void> addSearch(String query);
  Future<void> clear();
}

class RecentSearchesDataSourceImpl implements RecentSearchesDataSource {
  const RecentSearchesDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<List<String>> getRecentSearches() async {
    return _prefs.getStringList(StorageKeys.recentSearches) ?? const [];
  }

  @override
  Future<void> addSearch(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final List<String> current = List.of(
      _prefs.getStringList(StorageKeys.recentSearches) ?? const [],
    );
    current.removeWhere((q) => q.toLowerCase() == trimmed.toLowerCase());
    current.insert(0, trimmed);

    final List<String> capped =
        current.take(AppDefaults.maxRecentSearches).toList();
    await _prefs.setStringList(StorageKeys.recentSearches, capped);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(StorageKeys.recentSearches);
  }
}
