import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Translates Dio-level failures (timeouts, HTTP status codes, NewsAPI's own
/// `{status: "error", code: ..., message: ...}` envelope) into typed
/// [Exception]s that the rest of the data layer understands.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final Exception mapped = _map(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: mapped,
        response: err.response,
        type: err.type,
      ),
    );
  }

  Exception _map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _mapStatusCode(err);
      case DioExceptionType.cancel:
        return const ServerException('Request cancelled');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const NetworkException();
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Exception _mapStatusCode(DioException err) {
    final int? code = err.response?.statusCode;
    final dynamic data = err.response?.data;
    final String? apiMessage =
        data is Map<String, dynamic> ? data['message'] as String? : null;

    switch (code) {
      case 401:
        return InvalidApiKeyException(apiMessage ?? 'Invalid API key');
      case 426:
        return ServerException(apiMessage ?? 'Upgrade required');
      case 429:
        return RateLimitException(apiMessage ?? 'Rate limit exceeded');
      case 500:
      case 502:
      case 503:
        return ServerException(apiMessage ?? 'Server error');
      default:
        return ServerException(apiMessage ?? 'Unexpected server error');
    }
  }
}
