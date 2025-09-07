import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import '../config/app_config_provider.dart';
import '../network/network_service.dart';
import '../router/app_router.dart';
import '../storage/storage.dart';

final GetIt getIt = GetIt.instance;

/// Base abstraction for a feature/module DI registration.
/// Implement [register] to add synchronous registrations.
/// Override [registerAsync] if you need async initialization (awaited after sync phase).
abstract class FeatureDiModule {
  void register(GetIt getIt);
  Future<void> registerAsync(GetIt getIt) async {}
  String get name => runtimeType.toString();
}

bool _coreRegistered = false;

void _registerCore() {
  if (_coreRegistered) return;
  // Core singletons (idempotent checks to avoid duplicate registration in tests)
  if (!getIt.isRegistered<AppConfig>()) {
    getIt.registerLazySingleton<AppConfig>(() => AppConfigProvider.instance);
  }
  if (!getIt.isRegistered<AppStorage>()) {
    getIt.registerLazySingleton<AppStorage>(() => HiveAppStorage.instance);
  }
  if (!getIt.isRegistered<NetworkService>()) {
    getIt.registerLazySingleton<NetworkService>(() => NetworkService.instance);
  }
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() => getIt<NetworkService>().dio);
  }
  if (!getIt.isRegistered<AppRouter>()) {
    getIt.registerLazySingleton<AppRouter>(AppRouter.new);
  }
  _coreRegistered = true;
}

/// Configure global + feature dependencies.
/// Pass a list of [featureModules] from each feature package/folder.
Future<void> configureDependencies({
  List<FeatureDiModule> featureModules = const [],
}) async {
  _registerCore();

  // First do all sync registrations so dependencies are available for async steps.
  for (final m in featureModules) {
    m.register(getIt);
  }
  // Then run async hooks in sequence (can be parallelized if needed later).
  for (final m in featureModules) {
    await m.registerAsync(getIt);
  }
}
