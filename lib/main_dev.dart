import 'package:flutter/material.dart';

import 'app.dart';
import 'core/utils/logger.dart';
import 'flavors.dart';

void main() {
  F.appFlavor = Flavor.dev;
  Logger.i('Starting app in ${F.name} flavor');

  runApp(const App());
}
