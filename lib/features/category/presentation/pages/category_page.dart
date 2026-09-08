import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/failure_message_mapper.dart';
import '../../../../core/widgets/article_card.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../home/domain/entities/article.dart';
import '../providers/category_provider.dart';

/// Category detail page: header, featured (first) article, then a paginated
/// vertical list of the rest — per the spec's
/// Header -> Featured -> Vertical List -> Pagination flow.
class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({required this.category, super.key});

  final String category;

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(categoryNewsProvider(widget.category).notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CategoryState state = ref.watch(categoryNewsProvider(widget.category));
    final CategoryNewsViewModel viewModel =
        ref.read(categoryNewsProvider(widget.category).notifier);

    return Scaffold(
      appBar: AppBar(title: Text(NewsCategories.label(widget.category))),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: _buildBody(context, state, viewModel),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CategoryState state,
    CategoryNewsViewModel viewModel,
  ) {
    switch (state.status) {
      case CategoryStatus.loading:
        return const VerticalListSkeleton();
      case CategoryStatus.error:
        return ListView(
          children: [
            AppErrorWidget(
              message: state.failure?.displayMessage ?? 'Something went wrong.',
              onRetry: viewModel.refresh,
            ),
          ],
        );
      case CategoryStatus.empty:
        return const EmptyStateWidget(
          icon: Icons.article_outlined,
          title: 'No articles',
          message: 'There are no articles in this category right now.',
        );
      case CategoryStatus.loaded:
      case CategoryStatus.loadingMore:
        final Article featured = state.articles.first;
        final List<Article> rest = state.articles.skip(1).toList();

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: rest.length + 2,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(
                height: 220,
                child: BreakingNewsCard(
                  article: featured,
                  onTap: () => context.push('/article', extra: featured),
                ),
              );
            }
            final int itemIndex = index - 1;
            if (itemIndex >= rest.length) {
              return state.status == CategoryStatus.loadingMore
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink();
            }
            final article = rest[itemIndex];
            return HorizontalArticleTile(
              article: article,
              onTap: () => context.push('/article', extra: article),
            );
          },
        );
    }
  }
}
