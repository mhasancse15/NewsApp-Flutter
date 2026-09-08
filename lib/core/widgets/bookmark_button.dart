import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/bookmarks/presentation/providers/bookmarks_provider.dart';
import '../../features/home/domain/entities/article.dart';

/// Small circular bookmark toggle used on every article card and on the
/// article details page. Reads/writes through [bookmarksProvider] so all
/// instances across the app stay in sync.
class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({
    required this.article,
    super.key,
    this.size = 36,
    this.filledBackground = true,
  });

  final Article article;
  final double size;
  final bool filledBackground;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the whole state (not just the id set) ensures this rebuilds
    // whenever bookmarks change anywhere in the app.
    ref.watch(bookmarksProvider);
    final bool bookmarked =
        ref.read(bookmarksProvider.notifier).isBookmarked(article.uniqueId);

    final Widget icon = Icon(
      bookmarked ? Icons.bookmark : Icons.bookmark_border,
      color: bookmarked
          ? Theme.of(context).colorScheme.primary
          : (filledBackground ? Colors.white : null),
      size: size * 0.55,
    );

    return GestureDetector(
      onTap: () => ref.read(bookmarksProvider.notifier).toggle(article),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: filledBackground
              ? Colors.black.withValues(alpha: 0.45)
              : Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}
