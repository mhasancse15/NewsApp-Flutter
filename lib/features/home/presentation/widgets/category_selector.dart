import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// Horizontally scrolling row of filter chips shown just below the search
/// bar on Home ("All / Business / Tech / Sports / Health").
class CategorySelector extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const CategorySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _chipKeys = {};

  @override
  void initState() {
    super.initState();

    for (final category in NewsCategories.homeSelector) {
      _chipKeys[category] = GlobalKey();
    }
  }

  @override
  void didUpdateWidget(covariant CategorySelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selected != widget.selected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected();
      });
    }
  }

  void _scrollToSelected() {
    final key = _chipKeys[widget.selected];

    if (key?.currentContext == null) return;

    Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.3,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: NewsCategories.homeSelector.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final category = NewsCategories.homeSelector[i];

          final isSelected =
              category == widget.selected;

          return Container(
            key: _chipKeys[category],
            child: ChoiceChip(
              label: Text(
                category == 'All'
                    ? 'All'
                    : NewsCategories.label(category),
              ),
              selected: isSelected,
              selectedColor:
              Theme.of(context).colorScheme.primary,
              checkmarkColor: Colors.white,
              onSelected: (_) {
                widget.onSelected(category);
              },
            ),
          );
        },
      ),
    );
  }
}