/// Exceptions thrown by data sources. These are caught by repositories and
/// mapped to [Failure]s before crossing into the domain layer.
class ServerException implements Exception {
  const ServerException([this.message = 'Server error']);
  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);
  final String message;
}

class TimeoutException implements Exception {
  const TimeoutException([this.message = 'Request timed out']);
  final String message;
}

class InvalidApiKeyException implements Exception {
  const InvalidApiKeyException([this.message = 'Invalid API key']);
  final String message;
}

class RateLimitException implements Exception {
  const RateLimitException([this.message = 'Rate limit exceeded']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);
  final String message;
}
