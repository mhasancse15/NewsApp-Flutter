import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/article.dart';
import '../../domain/entities/source.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl({
    required NewsRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  final NewsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines({
    String? country,
    String? category,
    String? query,
    int page = 1,
    int pageSize = 20,
  }) {
    return _run(() async {
      final response = await _remoteDataSource.getTopHeadlines(
        country: country,
        category: category,
        query: query,
        page: page,
        pageSize: pageSize,
      );
      return response.articles
          .map((a) => a.toEntity(category: category))
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<Article>>> searchNews({
    required String query,
    String? language,
    String sortBy = 'publishedAt',
    DateTime? from,
    DateTime? to,
    int page = 1,
    int pageSize = 20,
  }) {
    return _run(() async {
      final response = await _remoteDataSource.getEverything(
        query: query,
        language: language,
        sortBy: sortBy,
        from: from,
        to: to,
        page: page,
        pageSize: pageSize,
      );
      return response.articles.map((a) => a.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<Article>>> getCategoryNews({
    required String category,
    String? country,
    int page = 1,
    int pageSize = 20,
  }) {
    return _run(() async {
      final response = await _remoteDataSource.getTopHeadlines(
        country: country,
        category: category,
        page: page,
        pageSize: pageSize,
      );
      return response.articles
          .map((a) => a.toEntity(category: category))
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<NewsSource>>> getSources({
    String? category,
    String? language,
    String? country,
  }) {
    return _run(() async {
      final response = await _remoteDataSource.getSources(
        category: category,
        language: language,
        country: country,
      );
      return response.sources.map((s) => s.toEntity()).toList();
    });
  }

  /// Centralizes: connectivity pre-check, exception -> Failure mapping, and
  /// empty-list -> [EmptyResponseFailure] translation.
  Future<Either<Failure, List<T>>> _run<T>(
    Future<List<T>> Function() action,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final List<T> result = await action();
      if (result.isEmpty) return const Left(EmptyResponseFailure());
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } on InvalidApiKeyException catch (e) {
      return Left(InvalidApiKeyFailure(e.message));
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
