import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetCategoryNewsParams {
  const GetCategoryNewsParams({
    required this.category,
    this.country,
    this.page = 1,
    this.pageSize = 20,
  });

  final String category;
  final String? country;
  final int page;
  final int pageSize;
}

class GetCategoryNewsUseCase {
  const GetCategoryNewsUseCase(this._repository);

  final NewsRepository _repository;

  Future<Either<Failure, List<Article>>> call(GetCategoryNewsParams params) {
    return _repository.getCategoryNews(
      category: params.category,
      country: params.country,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}
