import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Wraps its [child] in a shimmer effect using theme-aware colors.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    required this.width,
    required this.height,
    super.key,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final Color base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: base.withValues(alpha: 0.4),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Skeleton for the breaking-news carousel.
class BreakingNewsSkeleton extends StatelessWidget {
  const BreakingNewsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ShimmerBox(width: double.infinity, height: 200, borderRadius: 20),
    );
  }
}

/// Skeleton row mimicking a horizontal article-card section.
class HorizontalCardsSkeleton extends StatelessWidget {
  const HorizontalCardsSkeleton({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => const ShimmerBox(
          width: 160,
          height: 190,
        ),
      ),
    );
  }
}

/// Skeleton for vertical article lists (search results, category pages).
class VerticalListSkeleton extends StatelessWidget {
  const VerticalListSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const ShimmerBox(
        width: double.infinity,
        height: 96,
      ),
    );
  }
}

/// Skeleton for the article details page.
class ArticleDetailsSkeleton extends StatelessWidget {
  const ArticleDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ShimmerBox(width: double.infinity, height: 220, borderRadius: 20),
        SizedBox(height: 16),
        ShimmerBox(width: 120, height: 16),
        SizedBox(height: 12),
        ShimmerBox(width: double.infinity, height: 24),
        SizedBox(height: 8),
        ShimmerBox(width: 200, height: 24),
        SizedBox(height: 16),
        ShimmerBox(width: double.infinity, height: 14),
        SizedBox(height: 8),
        ShimmerBox(width: double.infinity, height: 14),
        SizedBox(height: 8),
        ShimmerBox(width: 250, height: 14),
      ],
    );
  }
}
