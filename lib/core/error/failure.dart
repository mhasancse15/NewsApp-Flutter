import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
///
/// The data layer never leaks Dio exceptions past its boundary — every
/// exception is caught and translated into one of these.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The request timed out.']);
}

class InvalidApiKeyFailure extends Failure {
  const InvalidApiKeyFailure([super.message = 'Invalid or missing API key.']);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure(
      [super.message = 'Rate limit exceeded. Please try again later.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on the server.']);
}

class EmptyResponseFailure extends Failure {
  const EmptyResponseFailure([super.message = 'No results found.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
