import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/article.dart';
import '../entities/source.dart';

/// Domain-layer contract for all news data access. Implementations live in
/// the data layer and must never leak Dio exceptions here — every error
/// path returns a [Failure] on the left of the [Either].
abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlines({
    String? country,
    String? category,
    String? query,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<Article>>> searchNews({
    required String query,
    String? language,
    String sortBy = 'publishedAt',
    DateTime? from,
    DateTime? to,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<Article>>> getCategoryNews({
    required String category,
    String? country,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<NewsSource>>> getSources({
    String? category,
    String? language,
    String? country,
  });
}
