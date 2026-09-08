import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/failure_message_mapper.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../domain/entities/article.dart';
import '../providers/home_provider.dart';
import '../widgets/breaking_news_carousel.dart';
import '../widgets/category_selector.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/news_section.dart';

const Map<String, String> _sectionEmoji = {
  'technology': '💻',
  'business': '💼',
  'sports': '⚽',
  'health': '🏥',
};

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeState state = ref.watch(homeViewModelProvider);
    final HomeViewModel viewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NewsFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeSearchBar(onTap: () => context.push('/search')),
                  const SizedBox(height: 12),
                  CategorySelector(
                    selected: viewModel.selectedCategory,
                    onSelected: viewModel.selectCategory,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildBody(context, state, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    HomeState state,
    HomeViewModel viewModel,
  ) {
    return switch (state) {
      HomeInitial() || HomeLoading() => const SliverToBoxAdapter(
          child: Column(
            children: [
              BreakingNewsSkeleton(),
              SizedBox(height: 24),
              HorizontalCardsSkeleton(),
              SizedBox(height: 24),
              HorizontalCardsSkeleton(),
            ],
          ),
        ),
      HomeError(:final failure) => SliverFillRemaining(
          child: AppErrorWidget(
            message: failure.displayMessage,
            onRetry: viewModel.refresh,
          ),
        ),
      HomeLoaded(:final breakingNews, :final sections) => SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (breakingNews.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('🔥 Breaking News'),
                ),
                const SizedBox(height: 12),
                BreakingNewsCarousel(
                  articles: breakingNews,
                  onArticleTap: (a) => _openArticle(context, a),
                ),
                const SizedBox(height: 24),
              ],
              for (final entry in sections.entries) ...[
                if (entry.key == 'sports')
                  VerticalNewsSection(
                    category: entry.key,
                    articles: entry.value,
                    emoji: _sectionEmoji[entry.key],
                    onArticleTap: (a) => _openArticle(context, a),
                    onSeeAll: () => context.push('/category/${entry.key}'),
                  )
                else
                  NewsSection(
                    category: entry.key,
                    articles: entry.value,
                    emoji: _sectionEmoji[entry.key],
                    onArticleTap: (a) => _openArticle(context, a),
                    onSeeAll: () => context.push('/category/${entry.key}'),
                  ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
    };
  }

  void _openArticle(BuildContext context, Article article) {
    context.push('/article', extra: article);
  }
}
