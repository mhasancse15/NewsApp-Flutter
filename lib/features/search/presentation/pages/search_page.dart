import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/failure_message_mapper.dart';
import '../../../../core/widgets/article_card.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../providers/search_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(searchViewModelProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SearchState state = ref.watch(searchViewModelProvider);
    final SearchViewModel viewModel = ref.read(searchViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search news, topics...',
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      viewModel.clearSearch();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            viewModel.onQueryChanged(value);
            setState(() {});
          },
          onSubmitted: viewModel.search,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.search(state.query),
        child: _buildBody(context, state, viewModel),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SearchState state,
    SearchViewModel viewModel,
  ) {
    switch (state.status) {
      case SearchStatus.idle:
        return _RecentSearches(
          searches: state.recentSearches,
          onTap: (q) {
            _controller.text = q;
            viewModel.search(q);
          },
          onClear: viewModel.clearHistory,
        );
      case SearchStatus.loading:
        return const VerticalListSkeleton();
      case SearchStatus.error:
        return ListView(
          children: [
            AppErrorWidget(
              message: state.failure?.displayMessage ?? 'Something went wrong.',
              onRetry: () => viewModel.search(state.query),
            ),
          ],
        );
      case SearchStatus.empty:
        return const EmptyStateWidget(
          icon: Icons.search_off_rounded,
          title: 'No results',
          message: 'Try a different keyword or check your spelling.',
        );
      case SearchStatus.loaded:
      case SearchStatus.loadingMore:
        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: state.articles.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index >= state.articles.length) {
              return state.status == SearchStatus.loadingMore
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink();
            }
            final article = state.articles[index];
            return HorizontalArticleTile(
              article: article,
              onTap: () => context.push('/article', extra: article),
            );
          },
        );
    }
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.searches,
    required this.onTap,
    required this.onClear,
  });

  final List<String> searches;
  final ValueChanged<String> onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.history,
        title: 'No recent searches',
        message: 'Search for topics, people, or events to get started.',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(onPressed: onClear, child: const Text('Clear')),
          ],
        ),
        const SizedBox(height: 8),
        for (final query in searches)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.history),
            title: Text(query),
            trailing: const Icon(Icons.north_west, size: 16),
            onTap: () => onTap(query),
          ),
      ],
    );
  }
}
