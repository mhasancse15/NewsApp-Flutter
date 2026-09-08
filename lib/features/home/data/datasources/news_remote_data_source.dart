import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/article_model.dart';
import 'news_api_client.dart';

/// Remote data source contract, so it can be mocked/faked in tests without
/// touching Dio directly.
abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getTopHeadlines({
    String? country,
    String? category,
    String? query,
    int page = 1,
    int pageSize = 20,
  });

  Future<NewsResponseModel> getEverything({
    required String query,
    String? language,
    String sortBy = 'publishedAt',
    DateTime? from,
    DateTime? to,
    int page = 1,
    int pageSize = 20,
  });

  Future<SourcesResponseModel> getSources({
    String? category,
    String? language,
    String? country,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  const NewsRemoteDataSourceImpl(this._client);

  final NewsApiClient _client;

  @override
  Future<NewsResponseModel> getTopHeadlines({
    String? country,
    String? category,
    String? query,
    int page = 1,
    int pageSize = 20,
  }) {
    return _guard(
      () => _client.getTopHeadlines(
        country: country,
        category: category,
        query: query,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  @override
  Future<NewsResponseModel> getEverything({
    required String query,
    String? language,
    String sortBy = 'publishedAt',
    DateTime? from,
    DateTime? to,
    int page = 1,
    int pageSize = 20,
  }) {
    return _guard(
      () => _client.getEverything(
        query: query,
        language: language,
        sortBy: sortBy,
        from: from,
        to: to,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  @override
  Future<SourcesResponseModel> getSources({
    String? category,
    String? language,
    String? country,
  }) {
    return _guard(
      () => _client.getSources(
        category: category,
        language: language,
        country: country,
      ),
    );
  }

  /// Runs [action], converting any [DioException] carrying a mapped
  /// [Exception] (see `ErrorInterceptor`) into that exception directly, so
  /// callers only ever catch our own exception types.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      final Object? mapped = e.error;
      if (mapped is Exception) throw mapped;
      throw const ServerException();
    }
  }
}
