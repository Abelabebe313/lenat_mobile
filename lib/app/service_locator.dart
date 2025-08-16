import 'package:get_it/get_it.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/services/cart_service.dart';
import 'package:lenat_mobile/services/feed_post_service.dart';
import 'package:lenat_mobile/services/graphql_service.dart';
import 'package:lenat_mobile/services/local_storage.dart';
import 'package:lenat_mobile/services/minio_service.dart';
import 'package:lenat_mobile/services/trivia_service.dart';
import 'package:lenat_mobile/services/trivia_progress_service.dart';
import 'package:lenat_mobile/services/market_service.dart';
import 'package:lenat_mobile/services/share_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<GraphQLService>(() => GraphQLService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator
      .registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  locator.registerLazySingleton(() => MinioService(
        endpoint: '92.205.167.80:9000',
        accessKey: 'lenat',
        secretKey: 'lenat123456789',
        bucketName: 'users',
        useSSL: false,
      ));
  locator.registerLazySingleton<FeedPostService>(() => FeedPostService());
  locator.registerLazySingleton<TriviaService>(() => TriviaService());
  locator.registerLazySingleton<TriviaProgressService>(
      () => TriviaProgressService());
  locator.registerLazySingleton<MarketPlaceService>(() => MarketPlaceService());
  locator.registerLazySingleton<CartService>(() => CartService());
  locator.registerLazySingleton<ShareService>(() => ShareService());
}
