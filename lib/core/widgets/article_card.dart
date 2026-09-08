import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/date_formatter.dart';
import '../../features/home/domain/entities/article.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';
import 'app_network_image.dart';
import 'bookmark_button.dart';

/// Card used inside horizontally scrollable "Technology" / "Business"
/// style sections. Reused across home, category, and search screens.
class ArticleCard extends StatelessWidget {
  const ArticleCard({
    required this.article,
    required this.onTap,
    super.key,
    this.width = 160,
  });

  final Article article;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppNetworkImage(
                  url: article.imageUrl,
                  width: width,
                  height: 100,
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: BookmarkButton(article: article, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleSmall.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${article.source.name} • ${DateFormatter.timeAgo(article.publishedAt)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wide card used for the breaking-news carousel: large image with an
/// overlaid gradient, category chip, headline, and metadata.
class BreakingNewsCard extends StatelessWidget {
  const BreakingNewsCard({
    required this.article,
    required this.onTap,
    super.key,
  });

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(
              url: article.imageUrl,
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.circular(20),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: _CategoryChip(category: article.category ?? 'general'),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: BookmarkButton(article: article),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${article.source.name} • '
                    '${DateFormatter.timeAgo(article.publishedAt)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal list-tile style card used in the Sports section and vertical
/// search/category result lists.
class HorizontalArticleTile extends StatelessWidget {
  const HorizontalArticleTile({
    required this.article,
    required this.onTap,
    super.key,
  });

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNetworkImage(url: article.imageUrl, width: 84, height: 76),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleSmall.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${article.source.name} • '
                    '${DateFormatter.timeAgo(article.publishedAt)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            BookmarkButton(article: article, size: 32, filledBackground: false),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends ConsumerWidget {
  const _CategoryChip({required this.category});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Explicitly watch the theme mode to ensure runtime reactivity
    ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.categoryAccent(category) : Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        NewsCategories.label(category),
        style: AppTypography.caption.copyWith(
          color: isDark ? Colors.white : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
