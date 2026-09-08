import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../home/domain/entities/article.dart';
import '../models/bookmark_model.dart';

/// Local persistence contract for bookmarked articles, keyed by
/// [Article.uniqueId] so re-bookmarking overwrites rather than duplicates.
abstract class BookmarkLocalDataSource {
  Future<List<Article>> getBookmarks();
  Future<void> addBookmark(Article article);
  Future<void> removeBookmark(String articleId);
  Future<bool> isBookmarked(String articleId);
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  const BookmarkLocalDataSourceImpl(this._box);

  final Box<Map<dynamic, dynamic>> _box;

  @override
  Future<List<Article>> getBookmarks() async {
    try {
      final List<Article> articles = _box.values
          .map(BookmarkModel.fromMap)
          .toList()
        ..sort((a, b) {
          final DateTime aDate = a.publishedAt ?? DateTime(0);
          final DateTime bDate = b.publishedAt ?? DateTime(0);
          return bDate.compareTo(aDate);
        });
      return articles;
    } catch (_) {
      throw const CacheException('Failed to read bookmarks');
    }
  }

  @override
  Future<void> addBookmark(Article article) async {
    try {
      await _box.put(article.uniqueId, BookmarkModel.toMap(article));
    } catch (_) {
      throw const CacheException('Failed to save bookmark');
    }
  }

  @override
  Future<void> removeBookmark(String articleId) async {
    try {
      await _box.delete(articleId);
    } catch (_) {
      throw const CacheException('Failed to remove bookmark');
    }
  }

  @override
  Future<bool> isBookmarked(String articleId) async {
    return _box.containsKey(articleId);
  }
}

/// Opens (once) and exposes the Hive box used for bookmark storage.
Future<Box<Map<dynamic, dynamic>>> openBookmarksBox() {
  return Hive.openBox<Map<dynamic, dynamic>>(StorageKeys.bookmarksBox);
}
