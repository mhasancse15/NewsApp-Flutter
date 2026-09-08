import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_top_headlines_usecase.dart';

final getTopHeadlinesUseCaseProvider = Provider<GetTopHeadlinesUseCase>(
  (ref) => GetTopHeadlinesUseCase(ref.watch(newsRepositoryProvider)),
);

/// Strongly typed state for the whole home feed (breaking news + every
/// category rail), matching the `NewsState` shape requested in the spec.
sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.breakingNews,
    required this.sections,
  });

  final List<Article> breakingNews;

  /// category key -> articles, in [NewsCategories.homeSelector] order
  /// (minus "All").
  final Map<String, List<Article>> sections;
}

class HomeError extends HomeState {
  const HomeError(this.failure);
  final Failure failure;
}

/// Drives the Home screen: loads breaking news (top headlines for the
/// selected filter) plus one horizontal rail per remaining category.
class HomeViewModel extends Notifier<HomeState> {
  late final GetTopHeadlinesUseCase _getTopHeadlines;
  String _selectedCategory = 'All';

  String get selectedCategory => _selectedCategory;

  @override
  HomeState build() {
    _getTopHeadlines = ref.watch(getTopHeadlinesUseCaseProvider);
    _load();
    return const HomeInitial();
  }

  Future<void> selectCategory(String category) async {
    _selectedCategory = category;
    await _load();
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    state = const HomeLoading();

    final breakingResult = await _getTopHeadlines(
      GetTopHeadlinesParams(
        country: AppDefaults.country,
        category:
            _selectedCategory == 'All' ? null : _selectedCategory.toLowerCase(),
        pageSize: 8,
      ),
    );

    await breakingResult.match(
      (failure) async => state = HomeError(failure),
      (breaking) async {
        final Map<String, List<Article>> sections = {};
        for (final category in NewsCategories.homeSelector.skip(1)) {
          final sectionResult = await _getTopHeadlines(
            GetTopHeadlinesParams(
              country: AppDefaults.country,
              category: category,
              pageSize: 6,
            ),
          );
          sectionResult.match(
            (_) => sections[category] = const [],
            (articles) => sections[category] = articles,
          );
        }
        state = HomeLoaded(breakingNews: breaking, sections: sections);
      },
    );
  }
}

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, HomeState>(HomeViewModel.new);
