import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/article/presentation/pages/article_details_page.dart';
import '../../features/bookmarks/presentation/pages/bookmarks_page.dart';
import '../../features/category/presentation/pages/categories_page.dart';
import '../../features/category/presentation/pages/category_page.dart';
import '../../features/home/domain/entities/article.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/more_page.dart';
import '../widgets/scaffold_with_nav_bar.dart';
import 'not_found_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Centralized routing table:
/// `/`, `/home`, `/search`, `/article`, `/category/:category`,
/// `/bookmarks`, `/categories`, `/more`.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bookmarks',
              builder: (context, state) => const BookmarksPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              builder: (context, state) => const CategoriesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              builder: (context, state) => const MorePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/',
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/article',
      builder: (context, state) {
        final article = state.extra as Article?;
        if (article == null) return const NotFoundPage();
        return ArticleDetailsPage(article: article);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/category/:category',
      builder: (context, state) {
        final String category = state.pathParameters['category']!;
        return CategoryPage(category: category);
      },
    ),
  ],
);
