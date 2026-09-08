import 'package:equatable/equatable.dart';

/// The publisher of an [Article], e.g. "BBC News".
class Source extends Equatable {
  const Source({required this.name, this.id});

  final String? id;
  final String name;

  static const Source unknown = Source(name: 'Unknown');

  @override
  List<Object?> get props => [id, name];
}

/// A full news source as returned by the `/top-headlines/sources` endpoint,
/// distinct from the lightweight [Source] embedded in each article.
class NewsSource extends Equatable {
  const NewsSource({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.language,
    required this.country,
    this.url,
  });

  final String id;
  final String name;
  final String description;
  final String? url;
  final String category;
  final String language;
  final String country;

  @override
  List<Object?> get props => [id, name, description, url, category, language, country];
}
