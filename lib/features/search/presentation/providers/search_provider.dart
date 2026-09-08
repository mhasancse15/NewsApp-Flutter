import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../home/domain/entities/article.dart';
import '../../data/datasources/recent_searches_data_source.dart';
import '../../domain/usecases/search_news_usecase.dart';

/// Overridden in `main.dart` once `SharedPreferences.getInstance()` resolves.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main',
  );
});

final recentSearchesDataSourceProvider = Provider<RecentSearchesDataSource>(
  (ref) => RecentSearchesDataSourceImpl(ref.watch(sharedPreferencesProvider)),
);

final searchNewsUseCaseProvider = Provider<SearchNewsUseCase>(
  (ref) => SearchNewsUseCase(ref.watch(newsRepositoryProvider)),
);

enum SearchStatus { idle, loading, loadingMore, loaded, empty, error }

class SearchState {
  const SearchState({
    this.status = SearchStatus.idle,
    this.query = '',
    this.articles = const [],
    this.recentSearches = const [],
    this.page = 1,
    this.hasReachedMax = false,
    this.failure,
  });

  final SearchStatus status;
  final String query;
  final List<Article> articles;
  final List<String> recentSearches;
  final int page;
  final bool hasReachedMax;
  final Failure? failure;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<Article>? articles,
    List<String>? recentSearches,
    int? page,
    bool? hasReachedMax,
    Failure? failure,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      articles: articles ?? this.articles,
      recentSearches: recentSearches ?? this.recentSearches,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      failure: failure,
    );
  }
}

/// Drives the Search screen: debounces input, paginates `/everything`
/// results, and persists recent search history.
class SearchViewModel extends Notifier<SearchState> {
  late final SearchNewsUseCase _searchNews;
  late final RecentSearchesDataSource _recentSearchesDataSource;
  Timer? _debounce;
  static const int _pageSize = 20;

  @override
  SearchState build() {
    _searchNews = ref.watch(searchNewsUseCaseProvider);
    _recentSearchesDataSource = ref.watch(recentSearchesDataSourceProvider);
    ref.onDispose(() => _debounce?.cancel());
    _loadRecentSearches();
    return const SearchState();
  }

  Future<void> _loadRecentSearches() async {
    final List<String> recent = await _recentSearchesDataSource
        .getRecentSearches();
    state = state.copyWith(recentSearches: recent);
  }

  /// Called on every keystroke; only fires the actual request after
  /// [AppDefaults.searchDebounce] of inactivity.
  void onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      state = state.copyWith(status: SearchStatus.idle, query: '', articles: []);
      return;
    }
    state = state.copyWith(query: query);
    _debounce = Timer(AppDefaults.searchDebounce, () => search(query));
  }

  Future<void> search(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) return;

    state = state.copyWith(
      status: SearchStatus.loading,
      query: trimmed,
      page: 1,
      hasReachedMax: false,
      articles: [],
    );

    final result = await _searchNews(
      SearchNewsParams(query: trimmed, page: 1, pageSize: _pageSize),
    );

    result.match(
      (failure) => state = state.copyWith(
        status: SearchStatus.error,
        failure: failure,
      ),
      (articles) => state = state.copyWith(
        status: articles.isEmpty ? SearchStatus.empty : SearchStatus.loaded,
        articles: articles,
        hasReachedMax: articles.length < _pageSize,
      ),
    );

    await _recentSearchesDataSource.addSearch(trimmed);
    await _loadRecentSearches();
  }

  /// Loads the next page; a no-op while already loading or once exhausted,
  /// to prevent duplicate in-flight requests.
  Future<void> loadMore() async {
    if (state.status == SearchStatus.loadingMore || state.hasReachedMax) {
      return;
    }
    if (state.query.isEmpty) return;

    final int nextPage = state.page + 1;
    state = state.copyWith(status: SearchStatus.loadingMore);

    final result = await _searchNews(
      SearchNewsParams(query: state.query, page: nextPage, pageSize: _pageSize),
    );

    result.match(
      (failure) => state = state.copyWith(
        status: SearchStatus.loaded,
        failure: failure,
      ),
      (articles) => state = state.copyWith(
        status: SearchStatus.loaded,
        articles: [...state.articles, ...articles],
        page: nextPage,
        hasReachedMax: articles.length < _pageSize,
      ),
    );
  }

  void clearSearch() {
    _debounce?.cancel();
    state = state.copyWith(status: SearchStatus.idle, query: '', articles: []);
  }

  Future<void> clearHistory() async {
    await _recentSearchesDataSource.clear();
    state = state.copyWith(recentSearches: []);
  }
}

final searchViewModelProvider =
    NotifierProvider<SearchViewModel, SearchState>(SearchViewModel.new);
