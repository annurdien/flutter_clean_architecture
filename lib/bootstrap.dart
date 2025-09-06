import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'core/dependency/app_dependency.dart';
import 'core/storage/hive_app_storage.dart';
import 'core/utils/logger.dart';
import 'feature/random_facts/dependency/random_fact_module.dart';
import 'flavors.dart';

/// Performs all synchronous + asynchronous app initialization before running the UI.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = flavor;
  final sw = Stopwatch()..start();
  Logger.i('Bootstrap started for flavor: ${F.name}');

  await HiveAppStorage.instance.init();
  await configureDependencies(featureModules: [RandomFactModule()]);

  sw.stop();
  Logger.i('Bootstrap finished in ${sw.elapsedMilliseconds}ms');
}

/// Wraps [bootstrap] + [runApp] in a guarded zone capturing uncaught errors.
Future<void> runBootstrap(Flavor flavor) async {
  await runZonedGuarded<Future<void>>(
    () async {
      await bootstrap(flavor);
      runApp(const App());
    },
    (error, stackTrace) {
      Logger.e('Uncaught zone error', error: error, stackTrace: stackTrace);
    },
  );
}
