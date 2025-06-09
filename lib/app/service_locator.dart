import 'package:get_it/get_it.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/services/graphql_service.dart';
import 'package:lenat_mobile/services/local_storage.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<GraphQLService>(() => GraphQLService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator
      .registerLazySingleton<LocalStorageService>(() => LocalStorageService());
}
