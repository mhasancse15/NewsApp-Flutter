import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlinesParams {
  const GetTopHeadlinesParams({
    this.country,
    this.category,
    this.query,
    this.page = 1,
    this.pageSize = 20,
  });

  final String? country;
  final String? category;
  final String? query;
  final int page;
  final int pageSize;
}

/// Fetches top headlines, optionally filtered by country/category/query.
class GetTopHeadlinesUseCase {
  const GetTopHeadlinesUseCase(this._repository);

  final NewsRepository _repository;

  Future<Either<Failure, List<Article>>> call(
    GetTopHeadlinesParams params,
  ) {
    return _repository.getTopHeadlines(
      country: params.country,
      category: params.category,
      query: params.query,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}
