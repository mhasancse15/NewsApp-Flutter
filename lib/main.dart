import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'features/bookmarks/data/datasources/bookmark_local_data_source.dart';
import 'features/bookmarks/presentation/providers/bookmarks_provider.dart';
import 'features/search/presentation/providers/search_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final bookmarksBox = await openBookmarksBox();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        bookmarksBoxProvider.overrideWithValue(bookmarksBox),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const NewsFlowApp(),
    ),
  );
}
