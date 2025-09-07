import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/dependency/app_dependency.dart';
import 'core/network/network_service.dart';
import 'core/storage/hive_app_storage.dart';
import 'core/utils/logger.dart';
import 'feature/random_facts/dependency/random_fact_module.dart';
// === mason:feature_imports === (do not remove) – new feature module imports will be injected above this line.
import 'flavors.dart';

/// Performs all synchronous + asynchronous app initialization before running the UI.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  F.appFlavor = flavor;
  final sw = Stopwatch()..start();
  Logger.setAlice(NetworkService.instance.alice);
  Logger.i('Bootstrap started for flavor: ${F.name}');

  await HiveAppStorage.instance.init();
  await configureDependencies(
    featureModules: [
      RandomFactModule(),
      // === mason:feature_modules === (do not remove) – new feature module instances will be injected above this line.
    ],
  );

  sw.stop();
  Logger.i('Bootstrap finished in ${sw.elapsedMilliseconds}ms');
}

/// Wraps [bootstrap] + [runApp] in a guarded zone capturing uncaught errors.
Future<void> runBootstrap(Flavor flavor) async {
  await runZonedGuarded<Future<void>>(
    () async {
      await bootstrap(flavor);
      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('es')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: const App(),
        ),
      );
    },
    (error, stackTrace) {
      Logger.e('Uncaught zone error', error: error, stackTrace: stackTrace);
    },
  );
}
