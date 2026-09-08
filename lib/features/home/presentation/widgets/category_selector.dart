import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// Horizontally scrolling row of filter chips shown just below the search
/// bar on Home ("All / Business / Tech / Sports / Health").
class CategorySelector extends StatelessWidget {
  const CategorySelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: NewsCategories.homeSelector.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final String category = NewsCategories.homeSelector[i];
          final bool isSelected = category == selected;
          return ChoiceChip(
            label: Text(
              category == 'All' ? 'All' : NewsCategories.label(category),
            ),
            selected: isSelected,
            checkmarkColor: Colors.white,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}
