import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/article.dart';
import '../repositories/bookmark_repository.dart';

class GetBookmarksUseCase {
  const GetBookmarksUseCase(this._repository);
  final BookmarkRepository _repository;

  Future<Either<Failure, List<Article>>> call() => _repository.getBookmarks();
}

class AddBookmarkUseCase {
  const AddBookmarkUseCase(this._repository);
  final BookmarkRepository _repository;

  Future<Either<Failure, Unit>> call(Article article) =>
      _repository.addBookmark(article);
}

class RemoveBookmarkUseCase {
  const RemoveBookmarkUseCase(this._repository);
  final BookmarkRepository _repository;

  Future<Either<Failure, Unit>> call(String articleId) =>
      _repository.removeBookmark(articleId);
}
