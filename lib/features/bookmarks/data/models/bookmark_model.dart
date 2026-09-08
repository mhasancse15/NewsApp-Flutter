import '../../../home/domain/entities/article.dart';
import '../../../home/domain/entities/source.dart';

/// Plain-map (de)serialization for [Article], used to persist bookmarks in
/// a Hive box without requiring generated TypeAdapters.
class BookmarkModel {
  const BookmarkModel(this.article);

  final Article article;

  static Map<String, dynamic> toMap(Article article) {
    return {
      'author': article.author,
      'title': article.title,
      'description': article.description,
      'url': article.url,
      'imageUrl': article.imageUrl,
      'publishedAt': article.publishedAt?.toIso8601String(),
      'content': article.content,
      'category': article.category,
      'sourceId': article.source.id,
      'sourceName': article.source.name,
    };
  }

  static Article fromMap(Map<dynamic, dynamic> map) {
    return Article(
      author: map['author'] as String?,
      title: (map['title'] as String?) ?? '(untitled)',
      description: map['description'] as String?,
      url: map['url'] as String?,
      imageUrl: map['imageUrl'] as String?,
      publishedAt: map['publishedAt'] != null
          ? DateTime.tryParse(map['publishedAt'] as String)
          : null,
      content: map['content'] as String?,
      category: map['category'] as String?,
      source: Source(
        id: map['sourceId'] as String?,
        name: (map['sourceName'] as String?) ?? 'Unknown',
      ),
    );
  }
}
