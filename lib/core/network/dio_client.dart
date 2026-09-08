import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_config.dart';
import 'error_interceptor.dart';

/// Thin wrapper around [Dio] configured for NewsAPI.org.
///
/// - Injects the API key as a query parameter on every request.
/// - Applies connect/receive timeouts.
/// - Logs requests/responses in debug builds only.
/// - Maps transport-level errors via [ErrorInterceptor].
class DioClient {
  DioClient() : dio = Dio(_baseOptions) {
    dio.interceptors.addAll([
      _ApiKeyInterceptor(),
      ErrorInterceptor(),
      if (kDebugMode) _LoggingInterceptor(),
    ]);
  }

  final Dio dio;

  static BaseOptions get _baseOptions => BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        responseType: ResponseType.json,
      );
}

class _ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.queryParameters.putIfAbsent('apiKey', () => ApiConfig.apiKey);
    handler.next(options);
  }
}

class _LoggingInterceptor extends Interceptor {
  final _encoder = const JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('➡️  ${options.method} ${options.uri}');
    if (options.data != null) {
      try {
        debugPrint('📦 Request Body:\n${_encoder.convert(options.data)}');
      } catch (_) {
        debugPrint('📦 Request Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      '✅ ${response.requestOptions.method} '
      '${response.requestOptions.uri} -> ${response.statusCode}',
    );
    if (response.data != null) {
      try {
        debugPrint('📄 Response Body:\n${_encoder.convert(response.data)}');
      } catch (_) {
        debugPrint('📄 Response Body: ${response.data}');
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '❌ ${err.requestOptions.method} ${err.requestOptions.uri} -> '
      '${err.error ?? err.message}',
    );
    if (err.response?.data != null) {
      try {
        debugPrint(
          '📄 Error Response Body:\n${_encoder.convert(err.response?.data)}',
        );
      } catch (_) {
        debugPrint('📄 Error Response Body: ${err.response?.data}');
      }
    }
    handler.next(err);
  }
}
