import '../error/failure.dart';

/// Maps [Failure]s to user-facing copy, keeping presentation-layer widgets
/// free of switch-on-type logic.
extension FailureMessageMapper on Failure {
  String get displayMessage => switch (this) {
        NetworkFailure() => 'No internet connection. Check your network and '
            'try again.',
        TimeoutFailure() => 'The request took too long. Please try again.',
        InvalidApiKeyFailure() => 'Invalid API key. Check your NewsAPI '
            'configuration.',
        RateLimitFailure() => 'Too many requests. Please wait a moment and '
            'try again.',
        EmptyResponseFailure() => 'No articles found.',
        CacheFailure() => 'Could not read local data.',
        ServerFailure() => 'Something went wrong. Please try again.',
        UnknownFailure() => 'An unexpected error occurred.',
      };
}
