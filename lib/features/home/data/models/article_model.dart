import '../../domain/entities/article.dart';
import 'source_model.dart';

/// DTO mirroring a single article object from the NewsAPI response.
class ArticleModel {
  const ArticleModel({
    required this.title,
    required this.source,
    this.author,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      author: json['author'] as String?,
      title: (json['title'] as String?) ?? '(untitled)',
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: _parseDate(json['publishedAt'] as String?),
      content: json['content'] as String?,
      source: SourceModel.fromJson(
        (json['source'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }

  final String? author;
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  final SourceModel source;

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Article toEntity({String? category}) {
    return Article(
      author: author,
      title: title,
      description: description,
      url: url,
      imageUrl: urlToImage,
      publishedAt: publishedAt,
      content: content,
      source: source.toEntity(),
      category: category,
    );
  }
}

/// DTO for the envelope NewsAPI wraps every list response in:
/// `{ "status": "ok", "totalResults": 20, "articles": [...] }`.
class NewsResponseModel {
  const NewsResponseModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawArticles = (json['articles'] as List?) ?? const [];
    return NewsResponseModel(
      status: (json['status'] as String?) ?? 'error',
      totalResults: (json['totalResults'] as int?) ?? 0,
      articles: rawArticles
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String status;
  final int totalResults;
  final List<ArticleModel> articles;
}

/// DTO for the `/top-headlines/sources` envelope.
class SourcesResponseModel {
  const SourcesResponseModel({required this.status, required this.sources});

  factory SourcesResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> raw = (json['sources'] as List?) ?? const [];
    return SourcesResponseModel(
      status: (json['status'] as String?) ?? 'error',
      sources: raw
          .map((e) => NewsSourceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String status;
  final List<NewsSourceModel> sources;
}
