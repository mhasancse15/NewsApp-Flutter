import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

/// Non-editable search bar shown on Home; tapping it navigates to the
/// dedicated Search screen where actual input/debouncing happens.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: scheme.onSurfaceVariant),
              const SizedBox(width: 10),
              Text(
                'Search news, topics...',
                style: AppTypography.bodyMedium.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
