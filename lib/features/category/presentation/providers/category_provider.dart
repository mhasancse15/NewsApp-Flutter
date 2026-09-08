import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../home/domain/entities/article.dart';
import '../../../home/domain/usecases/get_category_news_usecase.dart';

final getCategoryNewsUseCaseProvider = Provider<GetCategoryNewsUseCase>(
  (ref) => GetCategoryNewsUseCase(ref.watch(newsRepositoryProvider)),
);

enum CategoryStatus { loading, loadingMore, loaded, empty, error }

class CategoryState {
  const CategoryState({
    this.status = CategoryStatus.loading,
    this.articles = const [],
    this.page = 1,
    this.hasReachedMax = false,
    this.failure,
  });

  final CategoryStatus status;
  final List<Article> articles;
  final int page;
  final bool hasReachedMax;
  final Failure? failure;

  CategoryState copyWith({
    CategoryStatus? status,
    List<Article>? articles,
    int? page,
    bool? hasReachedMax,
    Failure? failure,
  }) {
    return CategoryState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      failure: failure,
    );
  }
}

/// One paginated feed per category, keyed by category name via
/// `family` so switching categories never mixes state.
class CategoryNewsViewModel extends FamilyNotifier<CategoryState, String> {
  late final GetCategoryNewsUseCase _getCategoryNews;
  static const int _pageSize = 20;
  late String _category;

  @override
  CategoryState build(String arg) {
    _category = arg;
    _getCategoryNews = ref.watch(getCategoryNewsUseCaseProvider);
    _load();
    return const CategoryState();
  }

  Future<void> _load() async {
    state = const CategoryState();
    final result = await _getCategoryNews(
      GetCategoryNewsParams(
        category: _category,
        country: AppDefaults.country,
        page: 1,
        pageSize: _pageSize,
      ),
    );
    result.match(
      (failure) =>
          state = state.copyWith(status: CategoryStatus.error, failure: failure),
      (articles) => state = state.copyWith(
        status: articles.isEmpty ? CategoryStatus.empty : CategoryStatus.loaded,
        articles: articles,
        hasReachedMax: articles.length < _pageSize,
      ),
    );
  }

  Future<void> refresh() => _load();

  Future<void> loadMore() async {
    if (state.status == CategoryStatus.loadingMore || state.hasReachedMax) {
      return;
    }
    final int nextPage = state.page + 1;
    state = state.copyWith(status: CategoryStatus.loadingMore);

    final result = await _getCategoryNews(
      GetCategoryNewsParams(
        category: _category,
        country: AppDefaults.country,
        page: nextPage,
        pageSize: _pageSize,
      ),
    );

    result.match(
      (failure) =>
          state = state.copyWith(status: CategoryStatus.loaded, failure: failure),
      (articles) => state = state.copyWith(
        status: CategoryStatus.loaded,
        articles: [...state.articles, ...articles],
        page: nextPage,
        hasReachedMax: articles.length < _pageSize,
      ),
    );
  }
}

final categoryNewsProvider =
    NotifierProvider.family<CategoryNewsViewModel, CategoryState, String>(
  CategoryNewsViewModel.new,
);
