import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/article_card.dart';
import '../../domain/entities/article.dart';

/// Section header with a title and a "See All" action, reused by every
/// category rail.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.onSeeAll,
    super.key,
    this.emoji,
  });

  final String title;
  final String? emoji;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            emoji != null ? '$emoji  $title' : title,
            style: AppTypography.headlineMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
            ),
          ),
          TextButton(onPressed: onSeeAll, child: const Text('See All')),
        ],
      ),
    );
  }
}

/// A titled horizontal rail of [ArticleCard]s — the reusable building block
/// for Technology / Business / etc. sections on the Home screen.
class NewsSection extends StatelessWidget {
  const NewsSection({
    required this.category,
    required this.articles,
    required this.onArticleTap,
    required this.onSeeAll,
    super.key,
    this.emoji,
  });

  final String category;
  final List<Article> articles;
  final ValueChanged<Article> onArticleTap;
  final VoidCallback onSeeAll;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: NewsCategories.label(category),
          emoji: emoji,
          onSeeAll: onSeeAll,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) => ArticleCard(
              article: articles[i],
              onTap: () => onArticleTap(articles[i]),
            ),
          ),
        ),
      ],
    );
  }
}

/// Vertical variant used specifically for the Sports section, per the
/// layout spec (image-left, text-right tiles stacked vertically).
class VerticalNewsSection extends StatelessWidget {
  const VerticalNewsSection({
    required this.category,
    required this.articles,
    required this.onArticleTap,
    required this.onSeeAll,
    super.key,
    this.emoji,
  });

  final String category;
  final List<Article> articles;
  final ValueChanged<Article> onArticleTap;
  final VoidCallback onSeeAll;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: NewsCategories.label(category),
          emoji: emoji,
          onSeeAll: onSeeAll,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final article in articles) ...[
                HorizontalArticleTile(
                  article: article,
                  onTap: () => onArticleTap(article),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
