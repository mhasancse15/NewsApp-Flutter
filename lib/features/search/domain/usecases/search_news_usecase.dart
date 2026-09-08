import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/article.dart';
import '../../../home/domain/repositories/news_repository.dart';

class SearchNewsParams {
  const SearchNewsParams({
    required this.query,
    this.language,
    this.sortBy = 'publishedAt',
    this.page = 1,
    this.pageSize = 20,
  });

  final String query;
  final String? language;
  final String sortBy;
  final int page;
  final int pageSize;
}

/// Wraps [NewsRepository.searchNews] (the `/everything` endpoint).
class SearchNewsUseCase {
  const SearchNewsUseCase(this._repository);

  final NewsRepository _repository;

  Future<Either<Failure, List<Article>>> call(SearchNewsParams params) {
    return _repository.searchNews(
      query: params.query,
      language: params.language,
      sortBy: params.sortBy,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}
