import 'package:equatable/equatable.dart';

import 'source.dart';

/// Core domain entity representing a single news article.
///
/// Deliberately independent of NewsAPI's response shape — the data layer is
/// responsible for mapping [ArticleModel] into this entity.
class Article extends Equatable {
  const Article({
    required this.title,
    required this.source,
    this.author,
    this.description,
    this.url,
    this.imageUrl,
    this.publishedAt,
    this.content,
    this.category,
  });

  final String? author;
  final String title;
  final String? description;
  final String? url;
  final String? imageUrl;
  final DateTime? publishedAt;
  final String? content;
  final Source source;

  /// Not part of the NewsAPI article payload itself, but attached by the
  /// repository when fetched via a category-scoped query so the UI can tag
  /// cards without re-deriving it.
  final String? category;

  /// Stable identity for bookmarking/list diffing purposes, since NewsAPI
  /// articles have no numeric id.
  String get uniqueId => url ?? '$title-${publishedAt?.toIso8601String()}';

  Article copyWith({String? category}) {
    return Article(
      title: title,
      source: source,
      author: author,
      description: description,
      url: url,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      content: content,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        author,
        title,
        description,
        url,
        imageUrl,
        publishedAt,
        content,
        source,
        category,
      ];
}
