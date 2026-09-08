import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/article.dart';

abstract class BookmarkRepository {
  Future<Either<Failure, List<Article>>> getBookmarks();
  Future<Either<Failure, Unit>> addBookmark(Article article);
  Future<Either<Failure, Unit>> removeBookmark(String articleId);
  Future<Either<Failure, bool>> isBookmarked(String articleId);
}
