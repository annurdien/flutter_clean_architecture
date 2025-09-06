import 'package:logger/logger.dart' as log;

import '../../flavors.dart';

abstract class ILogger {
  void t(String message);
  void d(String message);
  void i(String message);
  void w(String message);
  void e(String message, {Object? error, StackTrace? stackTrace});
  void f(String message, {Object? error, StackTrace? stackTrace});
}

class AppLogger implements ILogger {
  static log.Logger? _logger;

  static log.Logger get _instance {
    _logger ??= log.Logger(
      printer: log.PrefixPrinter(
        log.PrettyPrinter(
          printEmojis: true,
          colors: true,
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
        ),
        debug: '[${F.name.toUpperCase()}] ',
        trace: '[${F.name.toUpperCase()}] ',
        info: '[${F.name.toUpperCase()}] ',
        warning: '[${F.name.toUpperCase()}] ',
        error: '[${F.name.toUpperCase()}] ',
        fatal: '[${F.name.toUpperCase()}] ',
      ),
    );
    return _logger!;
  }

  @override
  void t(String message) => _instance.t(message);

  @override
  void d(String message) => _instance.d(message);

  @override
  void i(String message) => _instance.i(message);

  @override
  void w(String message) => _instance.w(message);

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _instance.e(message, error: error, stackTrace: stackTrace);

  @override
  void f(String message, {Object? error, StackTrace? stackTrace}) =>
      _instance.f(message, error: error, stackTrace: stackTrace);
}

class Logger {
  static final ILogger _logger = AppLogger();

  static void t(String message) => _logger.t(message);
  static void d(String message) => _logger.d(message);
  static void i(String message) => _logger.i(message);
  static void w(String message) => _logger.w(message);
  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
  static void f(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}
