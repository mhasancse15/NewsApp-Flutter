import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/failure_message_mapper.dart';
import '../../../../core/widgets/article_card.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../providers/bookmarks_provider.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BookmarksState state = ref.watch(bookmarksProvider);
    final BookmarksNotifier notifier = ref.read(bookmarksProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: RefreshIndicator(
        onRefresh: notifier.load,
        child: switch (state) {
          BookmarksInitial() || BookmarksLoading() => ListView(
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          BookmarksError(:final failure) => ListView(
              children: [
                AppErrorWidget(
                  message: failure.displayMessage,
                  onRetry: notifier.load,
                ),
              ],
            ),
          BookmarksLoaded(:final articles) => articles.isEmpty
              ? ListView(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: EmptyStateWidget(
                        icon: Icons.bookmark_border_rounded,
                        title: 'No bookmarks yet',
                        message:
                            'Articles you bookmark will show up here so you '
                            'can read them later, even offline.',
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: articles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return HorizontalArticleTile(
                      article: article,
                      onTap: () => context.push('/article', extra: article),
                    );
                  },
                ),
        },
      ),
    );
  }
}
