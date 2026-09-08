import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

const Map<String, IconData> _categoryIcons = {
  'business': Icons.work_outline_rounded,
  'technology': Icons.memory_rounded,
  'sports': Icons.sports_soccer_rounded,
  'health': Icons.health_and_safety_outlined,
  'science': Icons.science_outlined,
  'entertainment': Icons.movie_outlined,
  'general': Icons.public_rounded,
};

/// Grid of all NewsAPI categories; tapping one navigates to
/// `/category/:category`.
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: NewsCategories.all.length,
        itemBuilder: (context, index) {
          final String category = NewsCategories.all[index];
          final Color accent = AppColors.categoryAccent(category);
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.push('/category/$category'),
            child: Container(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _categoryIcons[category] ?? Icons.article_outlined,
                    color: accent,
                    size: 28,
                  ),
                  Text(
                    NewsCategories.label(category),
                    style: AppTypography.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
