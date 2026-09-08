/// Centralized API configuration for NewsAPI.org.
///
/// The API key is injected at build/run time via `--dart-define` and is
/// NEVER hardcoded in source code:
///
/// ```bash
/// flutter run --dart-define=NEWS_API_KEY=YOUR_API_KEY
/// ```
abstract class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = 'https://newsapi.org/v2';

  static const String apiKey = String.fromEnvironment('NEWS_API_KEY');

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
  static const String sources = '/top-headlines/sources';

  static const int defaultPageSize = 20;
}
