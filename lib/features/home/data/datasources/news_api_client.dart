import 'package:dio/dio.dart';

import '../../../../core/constants/api_config.dart';
import '../models/article_model.dart';

/// Thin, endpoint-specific wrapper around [Dio] for NewsAPI.org.
///
/// This is the only class in the app allowed to know about NewsAPI's exact
/// query parameter names. Everything above it (remote data source,
/// repository) speaks in domain terms.
class NewsApiClient {
  const NewsApiClient(this._dio);

  final Dio _dio;

  Future<NewsResponseModel> getTopHeadlines({
    String? country,
    String? category,
    String? query,
    int page = 1,
    int pageSize = ApiConfig.defaultPageSize,
    CancelToken? cancelToken,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConfig.topHeadlines,
      queryParameters: {
        if (country != null) 'country': country,
        if (category != null) 'category': category,
        if (query != null && query.isNotEmpty) 'q': query,
        'page': page,
        'pageSize': pageSize,
      },
      cancelToken: cancelToken,
    );
    return NewsResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<NewsResponseModel> getEverything({
    required String query,
    String? language,
    String sortBy = 'publishedAt',
    DateTime? from,
    DateTime? to,
    int page = 1,
    int pageSize = ApiConfig.defaultPageSize,
    CancelToken? cancelToken,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConfig.everything,
      queryParameters: {
        'q': query,
        if (language != null) 'language': language,
        'sortBy': sortBy,
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
        'page': page,
        'pageSize': pageSize,
      },
      cancelToken: cancelToken,
    );
    return NewsResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<SourcesResponseModel> getSources({
    String? category,
    String? language,
    String? country,
    CancelToken? cancelToken,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConfig.sources,
      queryParameters: {
        if (category != null) 'category': category,
        if (language != null) 'language': language,
        if (country != null) 'country': country,
      },
      cancelToken: cancelToken,
    );
    return SourcesResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
