import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/data/datasources/news_api_client.dart';
import '../../features/home/data/datasources/news_remote_data_source.dart';
import '../../features/home/data/repositories/news_repository_impl.dart';
import '../../features/home/domain/repositories/news_repository.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

/// Root Dio client. A single instance is shared by all feature API clients.
final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final newsApiClientProvider = Provider<NewsApiClient>((ref) {
  return NewsApiClient(ref.watch(dioClientProvider).dio);
});

final newsRemoteDataSourceProvider = Provider<NewsRemoteDataSource>((ref) {
  return NewsRemoteDataSourceImpl(ref.watch(newsApiClientProvider));
});

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
});

/// Shared news repository, consumed by home/search/category/article
/// features alike.
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    remoteDataSource: ref.watch(newsRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});
