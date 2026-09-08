/// Categories supported by NewsAPI, in the order they should render.
abstract class NewsCategories {
  const NewsCategories._();

  static const String alltab = 'All';
  static const String general = 'general';
  static const String business = 'business';
  static const String technology = 'technology';
  static const String sports = 'sports';
  static const String health = 'health';
  static const String science = 'science';
  static const String entertainment = 'entertainment';

  /// Categories shown in the home screen's horizontal selector, including
  /// the synthetic "All" filter (mapped to [general] when querying).
  static const List<String> homeSelector = [
    alltab,
    business,
    technology,
    sports,
    health,
  ];

  /// Full set of categories shown on the dedicated Categories screen.
  static const List<String> all = [
    business,
    technology,
    sports,
    health,
    science,
    entertainment,
    general,
  ];

  static String label(String category) {
    if (category.isEmpty) return category;
    return category[0].toUpperCase() + category.substring(1);
  }
}

/// Keys used for local persistence (SharedPreferences / Hive boxes).
abstract class StorageKeys {
  const StorageKeys._();

  static const String bookmarksBox = 'bookmarks_box';
  static const String settingsBox = 'settings_box';
  static const String themeMode = 'theme_mode';
  static const String recentSearches = 'recent_searches';
  static const String defaultCountry = 'default_country';
}

abstract class AppDefaults {
  const AppDefaults._();

  static const String country = 'us';
  static const int maxRecentSearches = 10;
  static const Duration searchDebounce = Duration(milliseconds: 500);
}
