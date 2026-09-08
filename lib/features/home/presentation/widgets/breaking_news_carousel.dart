import 'package:flutter/material.dart';

import '../../../../core/widgets/article_card.dart';
import '../../domain/entities/article.dart';

/// Horizontally swipeable breaking-news carousel with a dot page indicator,
/// used at the top of the Home screen.
class BreakingNewsCarousel extends StatefulWidget {
  const BreakingNewsCarousel({
    required this.articles,
    required this.onArticleTap,
    super.key,
  });

  final List<Article> articles;
  final ValueChanged<Article> onArticleTap;

  @override
  State<BreakingNewsCarousel> createState() => _BreakingNewsCarouselState();
}

class _BreakingNewsCarouselState extends State<BreakingNewsCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.articles.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final article = widget.articles[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: BreakingNewsCard(
                  article: article,
                  onTap: () => widget.onArticleTap(article),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.articles.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
