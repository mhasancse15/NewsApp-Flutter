import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/article.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_data_source.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  const BookmarkRepositoryImpl(this._localDataSource);

  final BookmarkLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<Article>>> getBookmarks() async {
    try {
      return Right(await _localDataSource.getBookmarks());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addBookmark(Article article) async {
    try {
      await _localDataSource.addBookmark(article);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeBookmark(String articleId) async {
    try {
      await _localDataSource.removeBookmark(articleId);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isBookmarked(String articleId) async {
    try {
      return Right(await _localDataSource.isBookmarked(articleId));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
