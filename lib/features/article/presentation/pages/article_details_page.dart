import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/bookmark_button.dart';
import '../../../home/domain/entities/article.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

/// Full article view. NewsAPI only ever returns a truncated `content`
/// field, so we always show what we have and offer a "Read Full Article"
/// button that opens [Article.url] externally.
class ArticleDetailsPage extends ConsumerWidget {
  const ArticleDetailsPage({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Explicitly watch themeModeProvider to force rebuild on theme change
    ref.watch(themeModeProvider);
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool hasUrl = article.url != null && article.url!.isNotEmpty;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: hasUrl ? () => _share(article) : null,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: BookmarkButton(article: article, filledBackground: false),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: AppNetworkImage(
                url: article.imageUrl,
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.categoryAccent(article.category!)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        article.category!.toUpperCase(),
                        style: AppTypography.caption.copyWith(
                          color: isDark ? Colors.white : scheme.onSurface,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: AppTypography.headlineLarge.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        article.source.name,
                        style: AppTypography.titleSmall.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                      if (article.author != null &&
                          article.author!.isNotEmpty) ...[
                        Text(
                          '  •  by ${article.author}',
                          style: AppTypography.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      Text(
                        '  •  ${DateFormatter.timeAgo(article.publishedAt)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  if (article.description != null &&
                      article.description!.isNotEmpty) ...[
                    Text(
                      article.description!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    _cleanContent(article.content) ??
                        'Full content is not available from this source.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (hasUrl)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _openExternal(context, article.url!),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Read Full Article'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// NewsAPI truncates `content` with a `"... [+N chars]"` suffix; strip it
  /// so we don't show a dangling fragment.
  String? _cleanContent(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final RegExp truncationPattern = RegExp(r'\s*\[\+\d+ chars\]\s*$');
    return raw.replaceFirst(truncationPattern, '');
  }

  Future<void> _share(Article article) async {
    await Share.share('${article.title}\n${article.url ?? ''}');
  }

  Future<void> _openExternal(BuildContext context, String url) async {
    final Uri uri = Uri.tryParse(url) ?? Uri();
    final bool launched = await canLaunchUrl(uri) &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this article link.')),
      );
    }
  }
}
