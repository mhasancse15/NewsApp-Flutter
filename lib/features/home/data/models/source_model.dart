import '../../domain/entities/source.dart';

/// DTO for the `source` object embedded in each article payload.
///
/// Kept separate from the [Source] domain entity so API shape changes never
/// ripple into the domain/presentation layers.
class SourceModel {
  const SourceModel({this.id, required this.name});

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'] as String?,
      name: (json['name'] as String?) ?? 'Unknown',
    );
  }

  final String? id;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  Source toEntity() => Source(id: id, name: name);
}

/// DTO for a full source object from `/top-headlines/sources`.
class NewsSourceModel {
  const NewsSourceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.language,
    required this.country,
    this.url,
  });

  factory NewsSourceModel.fromJson(Map<String, dynamic> json) {
    return NewsSourceModel(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? 'Unknown',
      description: (json['description'] as String?) ?? '',
      url: json['url'] as String?,
      category: (json['category'] as String?) ?? 'general',
      language: (json['language'] as String?) ?? 'en',
      country: (json['country'] as String?) ?? '',
    );
  }

  final String id;
  final String name;
  final String description;
  final String? url;
  final String category;
  final String language;
  final String country;

  NewsSource toEntity() => NewsSource(
        id: id,
        name: name,
        description: description,
        url: url,
        category: category,
        language: language,
        country: country,
      );
}
