import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/article.dart';
import '../../data/datasources/bookmark_local_data_source.dart';
import '../../data/repositories/bookmark_repository_impl.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../domain/usecases/bookmark_usecases.dart';

/// Must be overridden in `main.dart` after `Hive.openBox` completes, via
/// `ProviderScope(overrides: [bookmarksBoxProvider.overrideWithValue(box)])`.
final bookmarksBoxProvider = Provider<Box<Map<dynamic, dynamic>>>((ref) {
  throw UnimplementedError('bookmarksBoxProvider must be overridden in main');
});

final bookmarkLocalDataSourceProvider = Provider<BookmarkLocalDataSource>(
  (ref) => BookmarkLocalDataSourceImpl(ref.watch(bookmarksBoxProvider)),
);

final bookmarkRepositoryProvider = Provider<BookmarkRepository>(
  (ref) => BookmarkRepositoryImpl(ref.watch(bookmarkLocalDataSourceProvider)),
);

final getBookmarksUseCaseProvider = Provider(
  (ref) => GetBookmarksUseCase(ref.watch(bookmarkRepositoryProvider)),
);
final addBookmarkUseCaseProvider = Provider(
  (ref) => AddBookmarkUseCase(ref.watch(bookmarkRepositoryProvider)),
);
final removeBookmarkUseCaseProvider = Provider(
  (ref) => RemoveBookmarkUseCase(ref.watch(bookmarkRepositoryProvider)),
);

sealed class BookmarksState {
  const BookmarksState();
}

class BookmarksInitial extends BookmarksState {
  const BookmarksInitial();
}

class BookmarksLoading extends BookmarksState {
  const BookmarksLoading();
}

class BookmarksLoaded extends BookmarksState {
  const BookmarksLoaded(this.articles);
  final List<Article> articles;
}

class BookmarksError extends BookmarksState {
  const BookmarksError(this.failure);
  final Failure failure;
}

/// Owns the full bookmark list plus a fast id lookup set, so every article
/// card in the app can synchronously ask "is this bookmarked?" without a
/// storage round-trip.
class BookmarksNotifier extends Notifier<BookmarksState> {
  late final GetBookmarksUseCase _getBookmarks;
  late final AddBookmarkUseCase _addBookmark;
  late final RemoveBookmarkUseCase _removeBookmark;

  Set<String> _bookmarkedIds = {};

  @override
  BookmarksState build() {
    _getBookmarks = ref.watch(getBookmarksUseCaseProvider);
    _addBookmark = ref.watch(addBookmarkUseCaseProvider);
    _removeBookmark = ref.watch(removeBookmarkUseCaseProvider);
    load();
    return const BookmarksInitial();
  }

  bool isBookmarked(String articleId) => _bookmarkedIds.contains(articleId);

  Future<void> load() async {
    state = const BookmarksLoading();
    final result = await _getBookmarks();
    result.match(
      (failure) => state = BookmarksError(failure),
      (articles) {
        _bookmarkedIds = articles.map((a) => a.uniqueId).toSet();
        state = BookmarksLoaded(articles);
      },
    );
  }

  Future<void> toggle(Article article) async {
    final bool alreadyBookmarked = _bookmarkedIds.contains(article.uniqueId);
    if (alreadyBookmarked) {
      _bookmarkedIds.remove(article.uniqueId);
    } else {
      _bookmarkedIds.add(article.uniqueId);
    }
    // Optimistic list update when we already have a loaded list.
    if (state case BookmarksLoaded(:final articles)) {
      final List<Article> updated = alreadyBookmarked
          ? articles.where((a) => a.uniqueId != article.uniqueId).toList()
          : [article, ...articles];
      state = BookmarksLoaded(updated);
    }

    final result = alreadyBookmarked
        ? await _removeBookmark(article.uniqueId)
        : await _addBookmark(article);

    result.match(
      (failure) {
        // Roll back optimistic change on failure.
        if (alreadyBookmarked) {
          _bookmarkedIds.add(article.uniqueId);
        } else {
          _bookmarkedIds.remove(article.uniqueId);
        }
        load();
      },
      (_) {},
    );
  }
}

final bookmarksProvider =
    NotifierProvider<BookmarksNotifier, BookmarksState>(
  BookmarksNotifier.new,
);
